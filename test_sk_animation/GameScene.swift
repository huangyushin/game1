//
//  GameScene.swift
//  test_sk_animation
//
//  Created by huangyuhsin on 2018/12/20.
//  Copyright © 2018 None Co., Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
        
    private var bear = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []
        
    override func didMove(to view: SKView)
    {
        backgroundColor = .blue
        buildBear()
       
        //animateBear()
    }
        
        
    func buildBear()
    {
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames: [SKTexture] = []
        //讓Atlas圖庫輪播
        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages
        {
            let bearTextureName = "bear\(i)"
       walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        bearWalkingFrames = walkFrames
        
        let firstFrameTexture = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrameTexture)
        bear.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bear)
    }
    func animateBear() {
        /*
        let animation = SKAction.animate(with: bearWalkingFrames,timePerFrame: 0.1,resize: false,restore: true)
        let loop = SKAction.repeatForever(animation)
        bear.run(loop)
        bear.run(loop,withKey:"walkingInPlaceBear")
        */
        
        
        bear.run(SKAction.repeatForever(
            SKAction.animate(with: bearWalkingFrames,timePerFrame: 0.1,resize: false,restore: true)),withKey:"walkingInPlaceBear")
    }
    func moveBear(location: CGPoint) {
        // 1
        var multiplierForDirection: CGFloat
        
        // 2
        let bearSpeed = frame.size.width / 3.0
        
        // 3
        let moveDifference = CGPoint(x: location.x - bear.position.x, y: location.y - bear.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        // 4
        let moveDuration = distanceToMove / bearSpeed
        
        // 5
        if moveDifference.x < 0 {
            multiplierForDirection = 1.0
        } else {
            multiplierForDirection = -1.0
        }
        bear.xScale = abs(bear.xScale) * multiplierForDirection
        
        // 1
        if bear.action(forKey: "walkingInPlaceBear") == nil {
            // if legs are not moving, start them
            animateBear()
        }
        
        // 2 --->移動熊
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        // 3 --->移動到定點後停止所有Action
        let doneAction = SKAction.run(//SKAction.run可以直接執行一個閉包
        //這個閉包沒有特定格式
        {
        [weak self]  //所以你想傳個參數也行!!但若參數就是這個閉包所在類別，就是self啦!必須特別的改用[]來取代()
        in           //weak只是額外的修飾字，表示沒用的時候你可以回收(不寫也行)
        self?.bearMoveEnded()
        })
        
        // 4
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        bear.run(moveActionWithDone, withKey:"bearMoving")

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first!
        let location = touch.location(in: self)
        moveBear(location: location)
        
        /*
        var multiplierForDirection: CGFloat
        if location.x < frame.midX
        {
            // walk left
            multiplierForDirection = 1.0
        } else {
            // walk right
            multiplierForDirection = -1.0
        }
        /*點左(右)邊跑左(右)邊，簡單的寫法
        let xxx = SKAction.scale(to: -1, duration: 0.0)
        let yyy = SKAction.scale(to: 1, duration: 0.0)
        if multiplierForDirection == 1.0
        {
            bear.run(yyy)
        }else{
            bear.run(xxx)
        }
        */
        //厲害的寫法
        bear.xScale = abs(bear.xScale) * multiplierForDirection
        animateBear()
         */
    }
    func bearMoveEnded() {
        bear.removeAllActions()
    }
  //test
    func bearMoveEnded2() {
        bear.removeAllActions()
    }

}
    


