//
//  self.swift
//  Pop Boy
//
//  Created by Vinicius Hiroshi Higa on 13/05/19.
//  Copyright © 2019 Vinicius Higa. All rights reserved.
//

import UIKit
import SpriteKit

class Queen: SKSpriteNode {
    
    public var speedQueen: CGFloat = 50
    public var isQueenDefined = false
    

    
    /// Method for moving the Queen to a desired location
    ///
    /// - Parameters:
    ///   - sprite: Sprite Node that we are controlling
    ///   - location: <#location description#>
    ///   - dt: <#dt description#>
    ///   - queenFlag: <#queenFlag description#>
    func move(sprite: SKSpriteNode, location: CGPoint, dt: TimeInterval, queenFlag: SKSpriteNode) {
        
        if(location.x < 0)
        {
            if( location.x < self.position.x)
            {
                if(self.xScale > 0)
                {self.xScale = self.xScale * -1}
            }
            else
            {
                if(self.xScale < 0)
                {self.xScale = self.xScale * -1}
            }
        }
            
        else
        {
            if( location.x > self.position.x)
            {
                if(self.xScale < 0)
                {self.xScale = self.xScale * -1}
            }
            else
            {
                if(self.xScale > 0)
                {self.xScale = self.xScale * -1}
            }
        }
        
        //movimento ocorre enquanto a coordenada destino nao for a mesma atual
        if(self.position.x != location.x || location.y != self.position.y) {
            
            queenFlag.position.x = self.position.x
            // distancia x e y entre destino e local atual
            let offset = CGPoint(x: location.x - self.position.x, y: location.y - self.position.y)
            
            // calculo da hipotenusa
            let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
            
            // seno e cosseno o triangulo
            let direction = CGPoint(x: offset.x / CGFloat(length),
                                    y: offset.y / CGFloat(length))
            
            // velocidade do movimento
            let velocity = CGPoint(x: direction.x * speedQueen,
                                   y: direction.y * speedQueen)
            
            // deslocamento = (tempo entre as atualizacoes) x (velocidade determinada)
            let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                       y: velocity.y * CGFloat(dt))
            // efetuando deslocamento na posicao da rainha
            sprite.position = CGPoint(
                x: self.position.x + amountToMove.x,
                y: self.position.y + amountToMove.y)
            
        }
    }
    
}
