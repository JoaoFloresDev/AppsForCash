//
//  SettingsScene.swift
//  Aaahhh Boom
//
//  Created by Vinicius Hiroshi Higa on 17/04/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreditsScene: SKScene, SceneHandler {
    
    var previousScene: SKScene?
    
    private var btnGoBack : SKSpriteNode?
    private var backgroundMusic: SKAudioNode?
    private var audioEffects: SKAudioNode?
    
    private var lastFrameTime: TimeInterval?
    private var isFirstFrame = true
    
    override func didMove(to view: SKView) {
        
        //self.scaleMode = SKSceneScaleMode.aspectFill
        self.btnGoBack = self.childNode(withName: "Button Go Back") as? SKSpriteNode
        self.btnGoBack?.isUserInteractionEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        let found = self.atPoint(location)
        
        if let name = found.name {
            
            // Checking if we need to change the scene!
            
            if (name == "Button Go Back" || name == "Label Go Back") && self.previousScene != nil {
                

                let transitionAnim = SKTransition.fade(withDuration: 0.6) // Setting a fade effect between the scenes

                self.view?.presentScene(self.previousScene!, transition: transitionAnim)
            }
        }
        
    }
}
