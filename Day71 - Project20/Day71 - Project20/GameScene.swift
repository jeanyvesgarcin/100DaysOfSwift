//
//  GameScene.swift
//  Day71 - Project20
//
//  Created by Jean-Yves Garcin on 25/06/2023.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var scoreLabel: SKLabelNode!
    var timerCounter = 5
    
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16) // bottom left corner
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self) // where is touch
        let nodesAtPoint = nodes(at: location) // all nodes under finger
        
        // find only nodes which are SKSpriteNodes
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue } // find only fireworks
            
            // ensure only one colour is selected at a time
            for parent in fireworks { // parent is container node
                guard let firework = parent.children.first as? SKSpriteNode else { continue } // exit if can't find spriteNode in parent node
                
                // are you currently selected and not equal to our new sprite colour
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework" // put it back to a regular firework
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0 // go back to default / white colour
        }
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        timerCounter -= 1
        
        if timerCounter <= 0 {
            gameTimer?.invalidate()
        } else {
            switch Int.random(in: 0...3) {
            case 0:
                // fire five, straight up
                createFireworks(xMovement: 0, x: 512, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
            case 1:
                // fire five, in a fan
                createFireworks(xMovement: 0, x: 512, y: bottomEdge)
                createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFireworks(xMovement: 100, x: 512 + 100, y: bottomEdge)
                createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
            case 2:
                // fire five, from the left to the right
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            case 3:
                // fire five, from the right to the left
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            default:
                break
            }
        }
        
        if timerCounter <= 0 {
            let gameOver = SKSpriteNode(imageNamed: "game-over")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
        }
    }
    
    func createFireworks(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 // colour by the full amount we specify
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000)) // path to follow
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let delay = SKAction.wait(forDuration: 1)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([delay, remove])
            emitter.run(sequence)
            
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
