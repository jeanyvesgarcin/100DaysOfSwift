//
//  GameScene.swift
//  Day87 - Project26
//
//  Created by Jean-Yves Garcin on 27/06/2023.
//

import CoreMotion
import SpriteKit

enum LetterType: Character {
    case wall = "x"
    case vortex = "v"
    case star = "s"
    case finishPoint = "f"
    case empty = " "
}

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

enum NodeNames: String {
    case wall
    case vortex
    case star
    case finish
    // case empty = " "
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchedPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    
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
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        score = 0
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchedPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchedPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
        //https://www.hackingwithswift.com/read/26/4/contacting-but-not-colliding
        // 4:26
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchedPosition = lastTouchedPosition {
            let diff = CGPoint(x: lastTouchedPosition.x - player.position.x, y: lastTouchedPosition.y - player.position.y)
            // mimic earths gravity aka / 10
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            // x and y swapped as we are in landscape
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        // reading from bottom to top, because on inverted y access in SpriteKit
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                // 64 is the block size and 32 for the center of the block, as SpriteKit positions items from the center
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == LetterType.wall.rawValue {
                    // load wall
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    
                    // will not move around with gravity
                    node.physicsBody?.isDynamic = false
                    
                    addChild(node)
                    
                } else if letter == LetterType.vortex.rawValue {
                    // load vortex
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = NodeNames.vortex.rawValue
                    node.position = position
                    
                    // spin forever
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    // it is a vortex for collision purposes
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    
                    // we want to be told about collisions
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    
                    // bounce off nothing
                    node.physicsBody?.collisionBitMask = 0
                    
                    addChild(node)
                    
                } else if letter == LetterType.star.rawValue {
                    // load star
                    let node = SKSpriteNode(imageNamed: "star")
                    node.name = NodeNames.star.rawValue
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    
                    node.position = position
                    addChild(node)
                } else if letter == LetterType.finishPoint.rawValue {
                    // load finish point
                    let node = SKSpriteNode(imageNamed: "finish")
                    node.name = NodeNames.finish.rawValue
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    
                    node.position = position
                    addChild(node)
                } else if letter == LetterType.empty.rawValue {
                    // this is an empty space - do nothing
                } else {
                    fatalError("Unknown level letter: '\(letter)'")
                }
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        
        // tell us about these
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == NodeNames.vortex.rawValue {
            // stop player rolling around like a ball so we can suck it into the vortex
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            // move ball over vortex
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == NodeNames.star.rawValue {
            node.removeFromParent()
            score += 1
        } else if node.name == NodeNames.finish.rawValue {
            // next level
        }
    }
}
