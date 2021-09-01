//
//  GameViewController.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    var player1Score = 0
    var player2Score = 0

    
    var angle: Int {
        Int(angleSlider.value)
    }
    
    var velocity: Int {
        Int(velocitySlider.value)
    }
    
    var currentScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentScene = scene as? GameScene
                currentScene?.gameVC = self
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleSlider.value = 45
        velocitySlider.value = 125
        angleChanged(self)
        velocityChanged(self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(angle)°"
    }

    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(velocity)"
    }

    @IBAction func launchTapped(_ sender: Any) {
        showHUDControls(false)
        currentScene?.launch(withAngle: angle, velocity: velocity)
    }
    
    func showHUDControls(_ showHudCtrls: Bool) {
        let value = !showHudCtrls
        
        angleSlider.isHidden = value
        angleLabel.isHidden = value
        velocitySlider.isHidden = value
        velocityLabel.isHidden = value
        launchButton.isHidden = value
    }
    
    func advanceTurn(to playerNumber: Int) {
        if playerNumber == 1 {
            turnLabel.text = "<<< PLAYER ONE : \(player1Score) points"
        } else {
            turnLabel.text = "\(player2Score) points : PLAYER TWO >>>"
        }
        
        showHUDControls(true)
    }
}
