//
//  BuildingNode.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import SpriteKit
import UIKit



class BuildingNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    func setup() {
        name = "building"
        currentImage = drawBuilding(of: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    func drawBuilding(of size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let renderedImage = renderer.image { context in
            let cgContext = context.cgContext
            
            let rectangle = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            
            let color: UIColor
            
            // Select random color for building
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor.BuildingColors.firstColor
            case 1:
                color = UIColor.BuildingColors.secondColor
            default:
                color = UIColor.BuildingColors.defaultColor
            }
            
            // Draw building
            color.setFill()
            cgContext.addRect(rectangle)
            cgContext.drawPath(using: .fill)
            
            // Draw windows with lights on or off at random
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, through: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        UIColor.WindowColors.lightOnColor.setFill()
                    } else {
                        UIColor.WindowColors.lightOffColor.setFill()
                    }
                    cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
        }
        
        return renderedImage
    }
}
