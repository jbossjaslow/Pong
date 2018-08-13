//
//  GameScene.swift
//  Pong
//
//  Created by Josh Jaslow on 2/20/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var pauseTouched:Bool = false
    var ballVelocity: [CGFloat] = [0,0]
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    
    var score = [Int]()
    var pauseButton = SKSpriteNode()
    
    var playerScore = SKLabelNode()
    var enemyScore = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        playerScore = self.childNode(withName: "playerScore") as! SKLabelNode
        enemyScore = self.childNode(withName: "enemyScore") as! SKLabelNode
        
        pauseButton = self.childNode(withName: "pause") as! SKSpriteNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position.y = (-self.frame.height / 2) + 50
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        startGame()
    }
    
    func startGame() {
        
        score = [0,0]
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
        
        let rand1 = randomInt(num: 21) - 10
        let rand2 = randomInt(num: 3) + 4
        
        ball.physicsBody?.applyImpulse(CGVector(dx: rand1, dy: rand2))
    }
    
    func stopGame() {
        if !pauseTouched {
            pauseButton.texture = SKTexture(image: UIImage(named: "play")!)
            ballVelocity[0] = (ball.physicsBody?.velocity.dx)! * (ball.physicsBody?.mass)!
            ballVelocity[1] = (ball.physicsBody?.velocity.dy)! * (ball.physicsBody?.mass)!
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pauseTouched = true
        }
        else {
            pauseButton.texture = SKTexture(image: UIImage(named: "pause")!)
            ball.physicsBody?.applyImpulse(CGVector(dx: ballVelocity[0], dy: ballVelocity[1]))
            pauseTouched = false
        }
    }
    
    func randomInt(num: Int) -> Int {
        
        return Int(arc4random_uniform(UInt32(num))) + 1
    }
    
    func addScore(playerWhoWon: SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == player {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: randomInt(num: 21) - 10, dy: randomInt(num: 5) + 5))
        }
        else{
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: randomInt(num: 21) - 10, dy: -(randomInt(num: 5) + 5)))
        }
        
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.atPoint(location) == self.pauseButton {
                stopGame()
            }
            
            else if currentGameType == .twoPlayer {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
            else {
                player.run(SKAction.moveTo(x: location.x, duration: 0.2)) //gives slight delay to player, can make 0 for perfect feedback
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .twoPlayer {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
            else if self.atPoint(location) != self.pauseButton {
                player.run(SKAction.moveTo(x: location.x, duration: 0.2)) //gives slight delay to player, can make 0 for perfect feedback
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.2))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.9))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.6))
            break
        case .twoPlayer:
            
            break
        }
        
        if ball.position.y <= player.position.y - 30 {
            addScore(playerWhoWon: enemy)
        }
        else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: player)
        }
    }
}







