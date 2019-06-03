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
    var timer:SKLabelNode!
    
    func initGame() {
        score = 0
        ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
    }
    
    func overGame(overType:Int){
        let overHint = self.childNode(withName: "gameoverLabel") as! SKLabelNode
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0 )
        self.childNode(withName: "gameoverLabel")?.isHidden = false
        if(overType==1){
            overHint.fontColor = UIColor.yellow
            overHint.text = "CONGRATULATION"
            overHint.setScale(2.0)
        }else if(overType==2){
            overHint.fontColor = UIColor.red
            overHint.text = "GAME OVER"
            overHint.setScale(3.0)
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        scoreBoard = self.childNode(withName: "score") as! SKLabelNode
        timer = self.childNode(withName: "timer") as! SKLabelNode
        timer.setScale(4.0)
        //設定遊戲邊界
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        border.categoryBitMask = 4
        self.physicsBody = border
        //設定碰撞監聽器
        self.physicsWorld.contactDelegate = self
        
        run(.sequence([.run({self.timer.isHidden=false}),
                       .wait(forDuration: 1),
                       .run({self.timer.text="2"}),
                       .wait(forDuration: 1),
                       .run({self.timer.text="1"}),
                       .wait(forDuration: 1),
                       .run({self.timer.isHidden=true}),
                       .run({self.initGame()})
            ]))
        
        //給球移動力量
//        ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
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
    
    //碰撞事件
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name
        let nameB = contact.bodyB.node?.name
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        

        if(maskA==3 || maskB==3){ //球跟磚碰撞
            if(nameA=="block"){
                contact.bodyA.node?.removeFromParent()
            }else if(nameB=="block"){
                contact.bodyB.node?.removeFromParent()
            }
            score+=1
            var blocks = self.childNode(withName: "block")
            var children = self.children
            print(children.count)
            var isGameOver = true
            for node in children {
                if(node.name=="block"){
                    isGameOver = false
                }
            }
            if(isGameOver){
                self.overGame(overType: 1)
            }
            scoreBoard.text = "SCORE: "+String(score)
        }else if(maskA==10 || maskB==10){ //球跟底部碰撞
            self.overGame(overType: 2)
        }
    }
}
