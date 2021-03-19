//
//  MainScene.swift
//  Aaahhh Boom
//
//  Created by Vinicius Hiroshi Higa on 17/04/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
    
    weak var viewController: GameViewController!
    
    private var btnSettings : SKSpriteNode?
    private var btnCredits : SKSpriteNode?
    private var labelBestScore : SKLabelNode?
    private var backgroundMusic: SKAudioNode?
    private var audioEffects : SKAudioNode?
    
    override func didMove(to view: SKView) {
        
        //self.scaleMode = SKSceneScaleMode.resizeFill
        
        // Setting up the Button "Configs"
        
        let imgSettings = UIImage(named: "Settings Icon")
        let texSettings = SKTexture(image: imgSettings!)
        self.btnSettings = self.childNode(withName: "Button Settings") as? SKSpriteNode
        
        self.btnSettings?.texture = texSettings
        self.btnSettings?.isUserInteractionEnabled = false
        
        // Setting up the Button "Credits"
        
        let imgCredits = UIImage(named: "Credits Icon")
        let texCredits = SKTexture(image: imgCredits!)
        self.btnCredits = self.childNode(withName: "Button Credits") as? SKSpriteNode
        
        self.btnCredits?.texture = texCredits
        self.btnCredits?.isUserInteractionEnabled = false
        
        // Setting up the Label "Best Score"
        
        self.labelBestScore = self.childNode(withName: "Label Best Score") as? SKLabelNode
        
        // Getting the stored score (If exists)
        
        let score = UserDefaults.standard.string(forKey: "Score") ?? ""
        
        if score == "" {
            self.labelBestScore?.text = "Best Score: 0"
        }
        else {
            self.labelBestScore?.text = "Best Score: " + String(score)
        }
        
        // Setting up the Background Music
        
        self.backgroundMusic = self.childNode(withName: "Main Music") as? SKAudioNode
        self.audioEffects = self.childNode(withName: "Audio Effects") as? SKAudioNode
        
        var musicVolume = UserDefaults.standard.string(forKey: "Music Volume") ?? "0.5"
        var effectsVolume = UserDefaults.standard.string(forKey: "Effects Volume") ?? "0.5"
        
        self.backgroundMusic?.run(SKAction.changeVolume(to: Float(musicVolume)!, duration: 0))
        self.backgroundMusic?.autoplayLooped = true
        self.backgroundMusic?.run(SKAction.play())
        
        self.audioEffects?.run(SKAction.changeVolume(to: Float(effectsVolume)!, duration: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        let found = self.atPoint(location)
        
        if let name = found.name {
            
            // Checking if we need to change the scene!
            
            if name == "Button Settings" { // Move to Settings Scene
                if let scene = self.viewController.settingsScene {
                    
                    scene.scaleMode = .aspectFill // Setting the viewport size
                    scene.previousScene = self
                    
                    let transitionAnim = SKTransition.fade(withDuration: 0.6) // Setting a fade effect between the scenes
                    
                    //self.audioEffects?.run(SKAction.play()) // Doesn't have time to play
                    
                    self.view?.presentScene(scene, transition: transitionAnim)
                }
            }
            else if name == "Button Credits"{
                if let scene = SKScene(fileNamed: "CreditsScene") as? CreditsScene {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.previousScene = self
                    
                    let transitionAnim = SKTransition.fade(withDuration: 0.6) // Setting a fade effect between the scenes
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: transitionAnim)
                }
            }
            else { // Move to Game Scene
                

                if let scene = SKScene(fileNamed: "GameScene") as! GameScene? {
                    
                    scene.scaleMode = .aspectFill // Setting the viewport size
                    scene.previousScene = self
                    scene.viewController = self.viewController
                    
                    let transitionAnim = SKTransition.reveal(with: .up, duration: 0.2) // Setting a fade effect between the scenes
                    
                    //self.audioEffects?.run(SKAction.play()) // Doesn't have time to play
                    
                    self.view?.presentScene(scene, transition: transitionAnim)
                    
                }
            }
        }
        
    }
    
    
}
