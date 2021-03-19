//
//  SettingsScene.swift
//  Aaahhh Boom
//
//  Created by Vinicius Hiroshi Higa on 17/04/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import SpriteKit
import GameplayKit

class SettingsScene: SKScene, SceneHandler {
    
    var previousScene: SKScene?
    weak var viewController: GameViewController!
    
    private var btnGoBack : SKSpriteNode?
    private var backgroundMusic: SKAudioNode?
    private var audioEffects: SKAudioNode?
    
    private var lastFrameTime: TimeInterval?
    private var isFirstFrame = true
    
    override func didMove(to view: SKView) {
        
        //self.scaleMode = SKSceneScaleMode.aspectFill
     
        self.btnGoBack = self.childNode(withName: "Button Go Back") as? SKSpriteNode
        self.btnGoBack?.isUserInteractionEnabled = false
        
        // Getting the stored score (If exists)
        
        self.viewController.volumeSlider?.isHidden = false
        self.viewController.effectsSlider?.isHidden = false
        
        // Setting up the Background Music and the Audio Effects
        
        var musicVolume = UserDefaults.standard.string(forKey: "Music Volume") ?? "0.5"
        var effectsVolume = UserDefaults.standard.string(forKey: "Effects Volume") ?? "0.5"
        
        self.viewController.volumeSlider?.value = Float(musicVolume)!
        self.viewController.effectsSlider?.value = Float(effectsVolume)!

        self.backgroundMusic = self.childNode(withName: "Main Music") as? SKAudioNode
        self.backgroundMusic?.run(SKAction.changeVolume(to: Float(musicVolume)!, duration: 0))
        self.backgroundMusic?.autoplayLooped = true
        self.backgroundMusic?.run(SKAction.play())
        
        self.audioEffects = self.childNode(withName: "Audio Effects") as? SKAudioNode
        self.audioEffects?.run(SKAction.changeVolume(to: Float(effectsVolume)!, duration: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        let found = self.atPoint(location)
        
        if let name = found.name {
            
            // Checking if we need to change the scene!
            
            if (name == "Button Go Back" || name == "Label Go Back") && self.previousScene != nil {
                
                self.viewController.volumeSlider?.isHidden = true
                self.viewController.effectsSlider?.isHidden = true
                
                let transitionAnim = SKTransition.fade(withDuration: 0.6) // Setting a fade effect between the scenes
                
                //self.audioEffects?.run(SKAction.play()) // Doesn't have time to play
                
                self.view?.presentScene(self.previousScene!, transition: transitionAnim)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.viewController.musicVolumeChanged) {
            
            let musicVolume = UserDefaults.standard.string(forKey: "Music Volume") ?? "0.5"
            
            self.backgroundMusic?.run(SKAction.changeVolume(to: Float(musicVolume)!, duration: 0))
            self.viewController.musicVolumeChanged = false
        }
        
        if (self.viewController.effectsVolumeChanged) {
            
            let effectsVolume = UserDefaults.standard.string(forKey: "Effects Volume") ?? "0.5"
            
            self.audioEffects?.run(SKAction.changeVolume(to: Float(effectsVolume)!, duration: 0))
            self.viewController.effectsVolumeChanged = false
            
            if (!self.isFirstFrame) {
                if currentTime - self.lastFrameTime! >= 0.5 {
                    self.audioEffects?.run(SKAction.play())
                    self.lastFrameTime = currentTime
                }
            }
            else {
                self.lastFrameTime = currentTime
                self.isFirstFrame = false
            }
        }
    }
    
}
