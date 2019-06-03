//
//  GameMainMenu.swift
//  breakout
//
//  Created by joe on 2019/6/1.
//  Copyright © 2019 laughterXiao. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameMainMenu: SKScene,SKPhysicsContactDelegate{
    var ball:SKSpriteNode!
    var paddle:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "PlayBall") as! SKSpriteNode
        paddle = self.childNode(withName: "PlayPaddle") as! SKSpriteNode
        
        //給球移動力量
        ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
        //設定遊戲邊界
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        border.categoryBitMask = 9
        self.physicsBody = border
        
        //設定碰撞監聽器
        self.physicsWorld.contactDelegate = self
    }
    
    //碰撞事件
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name
        let nameB = contact.bodyB.node?.name
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        
        
        if(maskA==4 || maskB==4){ //球跟標題碰撞
            let title:SKLabelNode = self.childNode(withName: "LaTitle") as! SKLabelNode
            title.fontColor = UIColor(red:   CGFloat.random(in: 0...1),
                                  green: CGFloat.random(in: 0...1),
                                  blue:  CGFloat.random(in: 0...1),
                                  alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        print(node.name)
        
        if(node.name == "LaStart"){
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        paddle.position.x = ball.position.x
    }
}
