//
//  Cockroach.swift
//  Pop Boy
//
//  Created by Vinicius Hiroshi Higa on 12/05/19.
//  Copyright © 2019 Vinicius Higa. All rights reserved.
//

import SpriteKit

class Cockroach: NSObject {

    public var speedCockroach: Float = 80 // t = S / V -> t = (GameScene.HeightSize or LargeSize) x speedCockroach (s)
    
    
    /// Method for spawning Cockroaches
    func spawnCockroach(gameScene : GameScene) {
        
        let cockroach = SKSpriteNode(imageNamed: "cockroach")
        cockroach.size = CGSize(width: 64, height: 64)
        cockroach.name = "cockroach"
        cockroach.zPosition = 1
        
        var duration: TimeInterval
        
        // animation figure
        let cockroachTexture = SKTexture(imageNamed: "barata0000")
        let cockroachTexture2 = SKTexture(imageNamed: "barata0001")
        let cockroachAnimated = [cockroachTexture, cockroachTexture2]
        
        cockroach.run(SKAction.repeatForever(SKAction.animate(with: cockroachAnimated, timePerFrame: 0.05)), withKey: "movecockroach")
        
        
        // amplitude do movimento da cockroach
        let rand2 = CGFloat((arc4random_uniform(20)+1)*10)
        
        // posicao da formiga em comum com a flag
        var randomPos: CGFloat
        
        // cria numero randomico para escolher por qual lado da tela vai surgir a cockroach
        let rand: Int = Int(arc4random_uniform(4))
        switch rand {
        case 0:
            // spawn na parte inferior da tela
            randomPos = CGFloat.random( min: GameScene.BoundLeft, max: (GameScene.BoundRight - rand2))
            cockroach.position = CGPoint( x: randomPos, y: -GameScene.HeightSize )
            gameScene.worldNode.addChild(cockroach)
            cockroach.zRotation = 1.5708
            
            let flag = SKSpriteNode(imageNamed: "flagHigher")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Higher"))
            flag.position = CGPoint( x: randomPos, y: GameScene.BoundHigher - CGFloat(15))
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.HeightSize)/Int(self.speedCockroach))
            let actionMove =    SKAction.sequence([
                SKAction.moveBy(x: CGFloat(rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(GameScene.HeightSize*2)/6, duration: duration/6)
                ])
            
            let actionFlag =
                SKAction.sequence([
                    SKAction.moveBy(x: CGFloat(rand2), y:0, duration: duration/6),
                    modColor,
                    SKAction.moveBy(x: CGFloat(-rand2)/2, y: 0, duration: duration/12)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([actionFlag, actionRemove]))
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 1:
            // spawn na parte superior da tela
            randomPos = CGFloat.random( min: GameScene.BoundLeft, max: (GameScene.BoundRight - rand2))
            cockroach.position = CGPoint( x: randomPos, y: GameScene.HeightSize )
            gameScene.worldNode.addChild(cockroach)
            cockroach.zRotation = 4.71239
            
            let flag = SKSpriteNode(imageNamed: "flagBottom")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Bottom"))
            flag.position = CGPoint( x: randomPos, y: GameScene.BoundBottom + CGFloat(15))
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.HeightSize)/Int(self.speedCockroach))
            let actionMove = SKAction.sequence([
                SKAction.moveBy(x: CGFloat(rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(GameScene.HeightSize*2)/6, duration: duration/6)
                ])
            
            let actionFlag =
                SKAction.sequence([
                    SKAction.moveBy(x: CGFloat(rand2), y:0, duration: duration/6),
                    modColor,
                    SKAction.moveBy(x: CGFloat(-rand2)/2, y: 0, duration: duration/12)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([actionFlag, actionRemove]))
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 2:
            // spawn na esquerda da tela
            randomPos = CGFloat.random( min: GameScene.BoundHigher, max: CGFloat(GameScene.BoundBottom - rand2))
            cockroach.position = CGPoint( x: -GameScene.LargeSize, y: randomPos)
            gameScene.worldNode.addChild(cockroach)
            
            let flag = SKSpriteNode(imageNamed: "flagLeft")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Left"))
            flag.position = CGPoint( x: GameScene.BoundLeft, y: randomPos)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.LargeSize)/Int(self.speedCockroach))
            let actionMove =
                SKAction.sequence([
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6)
                    ])
            
            let actionFlag =
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: CGFloat(rand2), duration: duration/6),
                    modColor,
                    SKAction.moveBy(x: 0, y: CGFloat(-rand2)/4, duration: duration/24)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([actionFlag, actionRemove]))
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        default:
            // spawn na direita da tela
            randomPos = CGFloat.random( min: GameScene.BoundHigher, max: CGFloat(GameScene.BoundBottom - rand2))
            cockroach.position = CGPoint( x: GameScene.LargeSize, y: randomPos)
            gameScene.worldNode.addChild(cockroach)
            cockroach.xScale = cockroach.xScale * -1
            
            let flag = SKSpriteNode(imageNamed: "flagRight")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Right"))
            flag.position = CGPoint( x: GameScene.BoundRight, y: randomPos)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.LargeSize)/Int(self.speedCockroach))
            let actionMove =
                SKAction.sequence([
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6)
                    ])
            
            let actionFlag =
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: CGFloat(rand2), duration: duration/6),
                    modColor,
                    SKAction.moveBy(x: 0, y: CGFloat(-rand2)/4, duration: duration/24)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([actionFlag, actionRemove]))
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
        }
    }
    
}
