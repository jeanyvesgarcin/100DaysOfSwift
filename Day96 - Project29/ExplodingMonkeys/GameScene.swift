//
//  GameScene.swift
//  Day96 - Project28
//
//  Created by Jean-Yves Garcin on 28/06/2023.
//

import GameplayKit
import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
    // case wind = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var rainParticles: SKEmitterNode!
    var gameOver: SKSpriteNode!
    
    var currentPlayer = 1
    
    var windDirection: Int = -4
    var windSpeed: CGFloat = 0.85
        
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        
        rainParticles = SKEmitterNode(fileNamed: "Rain.sks")
        rainParticles.position = CGPoint(x: size.width / 2, y: size.height)
        rainParticles.name = "rainParticle"
        rainParticles.targetNode = scene
        rainParticles.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
        rainParticles.zPosition = -1
        rainParticles.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        rainParticles.physicsBody?.affectedByGravity = true
        
        addChild(rainParticles)
        
        gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 50
        
        increaseDifficulty(delayAmount: 0)
        
        physicsWorld.contactDelegate = self
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
        
        if firstNode.name == "banana", secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana", secondNode.name == "player1" {
            destroy(player: player1)
        }
        
        if firstNode.name == "banana", secondNode.name == "player2" {
            destroy(player: player2)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        // if off the left or right edge remove banana
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            // from centre
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        // can hit buildings or players
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        // can bounce off them and tell us when it does so
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        // very slow / use selectively - small object
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            // arm position of throw monkey
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            // give banana a push to the right
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            // give banana a push to the left
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        
        // they are a player
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        // bounce off bananas
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        // tell us when you hit bananas
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        // don't let them be moved around by gravity
        player1.physicsBody?.isDynamic = false
        
        // not the building that's slightly off the screen
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        // degrees to radians
        return Double(degrees) * .pi / 180
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        
        // where on the building was hit
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        // fix for small bug if banana hits two building at the same time, which would explode twice and would call change player twice. Node will instantly no longer be a banana with name cleared
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        if currentPlayer == 1 {
            viewController?.score.p1 += 10
        } else {
            viewController?.score.p2 += 10
        }
        
        changePlayer()
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if (self.viewController?.gameRound ?? 0) >= 3 {
            self.viewController?.launchButton.isEnabled = false
            self.viewController?.velocitySlider.isEnabled = false
            self.viewController?.angleSlider.isEnabled = false
            addChild(gameOver)
        } else {
            self.viewController?.gameRound += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController?.currentGame = newGame
                
                if self.currentPlayer == 1 {
                    self.viewController?.score.p1 += 100
                } else {
                    self.viewController?.score.p2 += 100
                }
                
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
            increaseDifficulty(delayAmount: 2)
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    func increaseDifficulty(delayAmount: Double) {
        if viewController?.wind.direction != nil {
            windDirection = Int.random(in: -1...4)
            windSpeed += 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayAmount) {
            self.viewController?.wind.direction = self.windDirection
            self.viewController?.wind.speed = self.windSpeed
        }
        physicsWorld.gravity = CGVector(dx: windDirection, dy: -8)
        physicsWorld.speed = windSpeed
        
        rainParticles.xAcceleration = physicsWorld.gravity.dx * 20
        rainParticles.yAcceleration = physicsWorld.gravity.dy * 5
    }
}
