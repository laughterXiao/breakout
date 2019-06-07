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
    var restart:SKLabelNode!
    var overHint:SKLabelNode!
    var score:Int = 0
    var timer:SKLabelNode!
    var isOverGame = true
    
    func initGame() {
        score = 0
        isOverGame = false
        restart.isHidden = true
        overHint.isHidden = true
        run(.sequence([.run({
                        self.timer.text="3"
                        self.timer.isHidden=false
                        }),
                       .wait(forDuration: 1),
                       .run({self.timer.text="2"}),
                       .wait(forDuration: 1),
                       .run({self.timer.text="1"}),
                       .wait(forDuration: 1),
                       .run({
                        self.timer.isHidden=true
                        self.ball.position.x = -38
                        self.ball.position.y = -510
                        self.ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
                       })
            ]))
        setBlock()
    }
    
    func setBlock(){
        let screen = self.frame
        
        for child in self.children{
            if(child.name=="block"){
                child.removeFromParent()
            }
        }
        
        for j in 1...3 {
            for i in -1...1 {
                let block:SKSpriteNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: screen.width*0.3, height: screen.height*0.05))
                block.name = "block"
                block.position.x = CGFloat(i)*screen.width*0.32
                block.position.y = -1*CGFloat(j)*screen.height*0.06+1*screen.height*0.45
                block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screen.width*0.3, height: screen.height*0.05))
                block.physicsBody?.affectedByGravity = false
                block.physicsBody?.isDynamic = false
                block.physicsBody?.categoryBitMask = 3
                block.physicsBody?.collisionBitMask = 2
                block.physicsBody?.fieldBitMask = 0
                block.physicsBody?.contactTestBitMask = 0
                block.color = UIColor(red:   CGFloat.random(in: 0...1),
                                      green: CGFloat.random(in: 0...1),
                                      blue:  CGFloat.random(in: 0...1),
                                      alpha: 1)
                self.addChild(block)
            }
        }
        
    }
    
    func overGame(overType:Int){
        
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0 )
        self.childNode(withName: "gameoverLabel")?.isHidden = false
        if(overType==1){ //success
            overHint.fontColor = UIColor.yellow
            overHint.text = "CONGRATULATION"
//            restart.text = "NEXT"
        }else if(overType==2){ //fail
            restart.isHidden = false
            overHint.fontColor = UIColor.red
            overHint.text = "GAME OVER"
            restart.text = "RESTART"
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        scoreBoard = self.childNode(withName: "score") as! SKLabelNode
        overHint = self.childNode(withName: "gameoverLabel") as! SKLabelNode
        restart = self.childNode(withName: "LaRestart") as! SKLabelNode
        timer = self.childNode(withName: "timer") as! SKLabelNode
//        timer.setScale(4.0)
        //設定遊戲邊界
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        border.categoryBitMask = 4
        self.physicsBody = border
        //設定碰撞監聽器
        self.physicsWorld.contactDelegate = self
        
//        overHint.setScale(2.0)
//        restart.setScale(2.0)
        
        initGame()
        
        //給球移動力量
//        ball.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 80 ))
    }
    
    //控制版擋板移動
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isOverGame){
            let touch = touches.first!
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if(node.name=="LaRestart"){
                initGame()
            }
        }else{
            for touch in touches {
                let touchLocation = touch.location(in: self)
                paddle.position.x = touchLocation.x
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(isOverGame){
            
        }else{
            for touch in touches {
                let touchLocation = touch.location(in: self)
                paddle.position.x = touchLocation.x
            }
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
            isOverGame = true
            for node in children {
                if(node.name=="block"){
                    isOverGame = false
                }
            }
            if(isOverGame){
                self.overGame(overType: 1)
            }
            scoreBoard.text = "SCORE: "+String(score)
        }else if(maskA==10 || maskB==10){ //球跟底部碰撞
            isOverGame = true
            self.overGame(overType: 2)
        }
    }
}
