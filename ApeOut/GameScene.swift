//
//  GameScene.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var gameVC: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1 {
        didSet {
            gameVC?.advanceTurn(to: currentPlayer)
        }
    }
    var player1Score = 0 {
        didSet {
            gameVC?.player1Score = player1Score
            if player1Score >= 3 {
                isGameOver = true
            }
        }
    }
    var player2Score = 0 {
        didSet {
            gameVC?.player2Score = player2Score
            if player2Score >= 3 {
                isGameOver = true
            }
        }
    }
    var isGameOver = false {
        didSet {
            if isGameOver {
                gameOver()
            }
        }
    }
    
    
    let BUILDING_LEFT_EDGE: CGFloat = -15
    let BUILDING_RIGHT_EDGE: CGFloat = 1024
    
    var BUILDING_RANDOM_WIDTH: Int {
        Int.random(in: 2...4) * 40
    }
    var BUILDING_RANDOM_HEIGHT: Int {
        Int.random(in: 300...600)
    }
    
    var buildings = [BuildingNode]()
    
    override func didMove(to view: SKView) {
        setupEnvironment()
        print("Game loaded")
    }
    
    func setupEnvironment() {
        // Setup background
        backgroundColor = UIColor.BackgroundColor.backgroundColor
        physicsWorld.contactDelegate = self
        
        createBuildings()
        createPlayers()
        createRandomGustOfWind()
    }
    
    func createRandomGustOfWind() {
        switch Int.random(in: 0...4) {
        case 0:
            physicsWorld.gravity = SKPhysicsWorld.GustsOfWinds.zeroWind
            gameVC?.windLabel.text = "No Wind"
        case 1:
            physicsWorld.gravity = SKPhysicsWorld.GustsOfWinds.slightLeftWind
            gameVC?.windLabel.text = "Slight Left Wind"
        case 2:
            physicsWorld.gravity = SKPhysicsWorld.GustsOfWinds.strongLeftWind
            gameVC?.windLabel.text = "Strong Left Wind"
        case 3:
            physicsWorld.gravity = SKPhysicsWorld.GustsOfWinds.slightRightWind
            gameVC?.windLabel.text = "Slight Right Wind"
        default:
            physicsWorld.gravity = SKPhysicsWorld.GustsOfWinds.strongRightWind
            gameVC?.windLabel.text = "Strong Right Wind"
        }
    }
    
    func createBuildings() {
        var currentX = BUILDING_LEFT_EDGE
        
        while currentX < BUILDING_RIGHT_EDGE {
            let size = CGSize(width: BUILDING_RANDOM_WIDTH, height: BUILDING_RANDOM_HEIGHT)
            currentX += size.width + 2 // Little bit spacing bw building
            let buildingPosition = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            
            let building = BuildingNode(color: .red, size: size)
            building.position = buildingPosition
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        player1 = createPlayer(number: 1, on: buildings[1])
        player2 = createPlayer(number: 2, on: buildings[buildings.count - 2])
    }
    
    func createPlayer(number: Int, on building: BuildingNode) -> SKSpriteNode {
        let player = SKSpriteNode(imageNamed: "player")
        player.name = "player\(number)"
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player.physicsBody?.isDynamic = false
        
        
        
        player.position = CGPoint(x: building.position.x, y: building.position.y + ((player.size.height + building.size.height) / 2))
        
        addChild(player)
        
        return player
    }
    
    func launch(withAngle angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radAngle = deg2rad(degrees: angle)
        
        createBanana()
        setupBananaThrow()
        throwBanana(at: radAngle, with: speed)
    }
    
    func throwBanana(at angle: Double, with speed: Double) {
        banana.physicsBody?.angularVelocity = -20
        var dx = speed * cos(angle)
        let dy = speed * sin(angle)
        if currentPlayer == 2 {
            dx *= -1
        }
        let impulse = CGVector(dx: dx, dy: dy)
        banana.physicsBody?.applyImpulse(impulse)
    }
    
    func setupBananaThrow() {
        let throwAnimation = getThrowAnimation()
        if currentPlayer == 1 {
            banana.position = getBananaPosition(for: player1)
            player1.run(throwAnimation)
        } else {
            banana.position = getBananaPosition(for: player2)
            player2.run(throwAnimation)
        }
    }
    
    func getBananaPosition(for player: SKSpriteNode) -> CGPoint{
        let xPos = player.position.x + ((currentPlayer == 1) ? -30 : 30)
        let yPos = player.position.y + 40
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getThrowAnimation() -> SKAction {
        let throwImage = "player\(currentPlayer)Throw"
        let raiseArm = SKAction.setTexture(SKTexture(imageNamed: throwImage))
        let pause = SKAction.wait(forDuration: 0.15)
        let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
        return SKAction.sequence([raiseArm, pause, lowerArm])
    }
    
    func createBanana() {
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(banana)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaDidHit(building: secondNode, at: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            bananaDidHit(player: player1)
            player2Score += 1
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            bananaDidHit(player: player2)
            player1Score += 1
        }
    }
    
    func bananaDidHit(building: SKNode, at location: CGPoint) {
        guard let building = building as? BuildingNode else  { return }
        createExplosion(at: location)
        
        let buildingContactPoint = convert(location, to: building)
        building.hit(at: buildingContactPoint)
        
        banana.name = "" // to prevent phantom collisions
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func bananaDidHit(player: SKNode) {
        createExplosion(for: player)
        
        banana.removeFromParent()
        player.removeFromParent()
        
        if !isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // No reference cycle here so no need of weak self
                self.changePlayer()
                self.instantiateNewScene()
            }
        }
    }
    
    func createExplosion(for player: SKNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
    }
    
    func createExplosion(at location: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = location
            addChild(explosion)
        }
    }
    
    func deg2rad(degrees: Int) -> Double {
        Double(degrees) * .pi / 180
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
    }
    
    func instantiateNewScene() {
        let newScene = GameScene(size: self.size)
        newScene.gameVC = gameVC
        gameVC?.currentScene = newScene
        newScene.currentPlayer = currentPlayer
        newScene.player1Score = player1Score
        newScene.player2Score = player2Score
        
        let transition = SKTransition.doorway(withDuration: 1.5)
        // MARK: Check later
        view?.presentScene(newScene, transition: transition)
    }
    
    func gameOver() {
        let winner = (player1Score > player2Score) ? 1 : 2
        gameVC?.showHUDControls(false)
        gameVC?.turnLabel.text = "GAME OVER: PLAYER \(winner) WINS"
    }
}
