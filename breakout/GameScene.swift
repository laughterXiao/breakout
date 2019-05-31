//
//  GameScene.swift
//  breakout
//
//  Created by joe on 2019/5/29.
//  Copyright © 2019 laughterXiao. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var ball:SKSpriteNode!
    var paddle:SKSpriteNode!
    var scoreBoard:SKLabelNode!
    var score:Int = 0
    
    func initGame() {
        
        score = 0
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        scoreBoard = self.childNode(withName: "score") as! SKLabelNode
        //let ball move
        ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        border.categoryBitMask = 4
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
    //控制版擋板移動
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    //碰撞消除磚塊
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name
        let nameB = contact.bodyB.node?.name
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        

        if(maskA==3 || maskB==3){
            if(nameA=="block"){
                contact.bodyA.node?.removeFromParent()
            }else if(nameB=="block"){
                contact.bodyB.node?.removeFromParent()
            }
            score+=1
            scoreBoard.text = "SCORE: "+String(score)
        }else if(maskA==10 || maskB==10){
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0 )
            self.childNode(withName: "gameoverLabel")?.isHidden = false
        }
    }
}
