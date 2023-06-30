//
//  GameScene.swift
//  Day99 - Milestone - Project28-29-30
//
//  Created by Jean-Yves Garcin on 30/06/2023.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var cards = [PlayingCard]()
    var wonGame: MessageNode!
    
    var symbols: [String] = ["🍦", "🍜", "🧇", "🥞", "🍩", "🍪", "🍫", "🥐", "🥖", "🍔", "🥧", "🍣"]
    var cardSymbols: [String] = []
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 0.9568627450980393, green: 0.803921568627451, blue: 0.1803921568627451, alpha: 1.0)
        symbols.shuffle()
        cardSymbols += symbols
        symbols.shuffle()
        cardSymbols += symbols
        
        createPlayingCards()
        
        physicsWorld.contactDelegate = self
        
        wonGame = MessageNode(color: .yellow, size: CGSize(width: 400, height: 110))
        wonGame.position = CGPoint(x: (size.width / 2), y: (size.height / 2))
        wonGame.setup(message: "You Won!",fontSize: 80)
        wonGame.zPosition = 5
    }
    
    func createPlayingCards() {
        var counter: Int = 0
        let blue = UIColor(red: 0.15294117647058825, green: 0.2, blue: 0.2235294117647059, alpha: 1.0)
        
        for currentX in stride(from: 255, to: CGFloat(size.width - 50), by: 125) {
            for currentY in stride(from: 175, to: CGFloat(size.height - 50), by: 175) {
                let size = CGSize(width: 100, height: 150)
                let card = PlayingCard(color: blue, size: size)
                // from centre
                card.position = CGPoint(x: currentX - (size.width / 2), y: currentY - (size.height / 2))
                card.setup(symbol: cardSymbols[counter])
                addChild(card)
                cards.append(card)
                counter += 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let item = node as? PlayingCard else { continue }
            
            if item.faceUp == true {
                continue
            }
            
            if totalFaceUpCards() == 2 {
                resetCards()
            }
            
            if item.name == "playingCard" {
                print("Tapped card")
                item.flip()
            }
            
            if totalFaceUpCards() == 2 {
                if cardsMatch() {
                    //
                }
            }
        }
    }
    
    func totalFaceUpCards() -> Int {
        let count = cards.filter { $0.faceUp == true }.count
        print("totalFaceUpCards=\(count)")
        return count
    }
    
    func resetCards() {
        for card in cards {
            if card.faceUp == true {
                card.flip()
            }
        }
    }
    
    func cardsMatch() -> Bool {
        let theseCards = cards.filter { $0.faceUp == true }
        
        if theseCards.count == 2 {
            if theseCards[0].cardSymbol == theseCards[1].cardSymbol {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards.removeAll(where: { $0.cardSymbol == theseCards[0].cardSymbol && $0.faceUp == true })
                    theseCards[0].removeFromParent()
                    theseCards[1].removeFromParent()
                    
                    if self.cards.count == 0 {
                        self.addChild(self.wonGame)
                    }
                }
                return true
            }
        }
        return false
    }
}
