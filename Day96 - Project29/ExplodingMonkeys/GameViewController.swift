//
//  GameViewController.swift
//  Day96 - Project28
//
//  Created by Jean-Yves Garcin on 28/06/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var windLabel: UILabel!

    struct WindItem {
        var speed: CGFloat
        var direction: Int
    }
    
    var wind: WindItem = WindItem(speed: 0, direction: 0) {
        didSet {
            let directionForce: Int = abs(wind.direction) * 10
            let direction: String = wind.direction > 0 ? "East" : "West"
            windLabel.text = "Wind: Speed=\(wind.speed.rounded()) Direction=\(direction) \(directionForce)"
        }
    }
    
    struct ScoreItem {
        var p1: Int
        var p2: Int
    }
    var score: ScoreItem = ScoreItem(p1: 0, p2: 0) {
        didSet {
            scoreLabel.text = "Player 1 : \(score.p1) / Player 2 : \(score.p2)"
        }
    }
    
    var gameRound: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        score.p1 = 0
        score.p2 = 0
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
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
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
}
