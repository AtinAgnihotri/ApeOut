//
//  GameScene.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import SpriteKit

class GameScene: SKScene {
    
    weak var gameVC: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    
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
        
        createBuildings()
        createPlayers()
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
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
