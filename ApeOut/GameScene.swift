//
//  GameScene.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import SpriteKit

class GameScene: SKScene {
    
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
