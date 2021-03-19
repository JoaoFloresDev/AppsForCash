//
//  Ant.swift
//  Pop Boy
//
//  Created by Vinicius Hiroshi Higa on 12/05/19.
//  Copyright © 2019 Vinicius Higa. All rights reserved.
//

import SpriteKit

class Ant: NSObject {

    public var speedAnt: Float = 80 // t = S x V -> t = (HeightSize or LargeSize) x speedAnt (s)
    
    /// Method for spawning Ants
    func spawnAnt(gameScene : GameScene) {
        
        let ant = SKSpriteNode(imageNamed: "ant")
        ant.size = CGSize(width: 64, height: 64)
        ant.name = "ant"
        ant.zPosition = 1
        
        // posicao da formiga em comum com a flag
        var randomPos: CGFloat
        
        //duracao do movimento da formiga
        var duration: TimeInterval
        
        // animation figure
        let antTexture = SKTexture(imageNamed: "formiga0000")
        let antTexture2 = SKTexture(imageNamed: "formiga0001")
        let antAnimated = [antTexture, antTexture2]
        
        ant.run(SKAction.repeatForever(SKAction.animate(with: antAnimated, timePerFrame: 0.05)), withKey: "moveAnt")
        
        // cria numero randomico para escolher por qual lado da tela vai surgir a ant
        let rand = Int(arc4random_uniform(4))
        switch rand {
        case 0:
            // spawn na parte inferior da tela
            randomPos = CGFloat.random( min: GameScene.BoundLeft, max: GameScene.BoundRight)
            ant.position = CGPoint( x: randomPos, y: -GameScene.HeightSize )
            gameScene.worldNode.addChild(ant)
            ant.zRotation = 1.5708
            
            let flag = SKSpriteNode(imageNamed: "flagHigher")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Higher"))
            flag.position = CGPoint( x: randomPos, y: GameScene.BoundHigher)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.HeightSize)/Int(self.speedAnt))
            let actionMove = SKAction.moveTo(y: GameScene.HeightSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/8)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 1:
            // spawn na parte superior da tela
            randomPos = CGFloat.random( min: GameScene.BoundLeft, max: GameScene.BoundRight)
            ant.position = CGPoint( x: randomPos, y: GameScene.HeightSize )
            gameScene.worldNode.addChild(ant)
            ant.zRotation = 4.71239
            
            let flag = SKSpriteNode(imageNamed: "flagBottom")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Bottom"))
            flag.position = CGPoint( x: randomPos, y: GameScene.BoundBottom)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.HeightSize)/Int(self.speedAnt))
            let actionMove = SKAction.moveTo(y: -GameScene.HeightSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/8)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 2:
            // spawn na esquerda da tela
            randomPos = CGFloat.random( min: GameScene.BoundHigher, max: GameScene.BoundBottom)
            ant.position = CGPoint( x: -GameScene.LargeSize, y: randomPos )
            gameScene.worldNode.addChild(ant)
            
            let flag = SKSpriteNode(imageNamed: "flagLeft")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Left"))
            flag.position = CGPoint( x: GameScene.BoundLeft, y: randomPos)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.LargeSize)/Int(self.speedAnt))
            let actionMove = SKAction.moveTo(x: GameScene.LargeSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/16)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        default:
            // spawn na direita da tela
            randomPos = CGFloat.random( min: GameScene.BoundHigher, max: GameScene.BoundBottom)
            ant.position = CGPoint( x: GameScene.LargeSize, y: randomPos )
            gameScene.worldNode.addChild(ant)
            ant.xScale = ant.xScale * -1
            
            let flag = SKSpriteNode(imageNamed: "flagRight")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Right"))
            flag.position = CGPoint( x: GameScene.BoundRight, y: randomPos)
            gameScene.worldNode.addChild(flag)
            
            duration = TimeInterval(Int(GameScene.LargeSize)/Int(self.speedAnt))
            let actionMove = SKAction.moveTo(x: -GameScene.LargeSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/16)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
        }
    }
    
}
