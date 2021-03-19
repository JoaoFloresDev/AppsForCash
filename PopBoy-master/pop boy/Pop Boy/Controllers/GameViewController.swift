import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var settingsScene : SettingsScene!
    var creditsScene : CreditsScene!
    var musicVolumeChanged: Bool = false
    var effectsVolumeChanged: Bool = false
    
    @IBOutlet var volumeSlider: UISlider?
    @IBOutlet var effectsSlider: UISlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.volumeSlider?.isHidden = true
        self.effectsSlider?.isHidden = true
        
        // Letting the access to the Game Scene "Options" more easy!
        // Because we need some communications with the UIKit! (e.g. Sliders)
        self.settingsScene = SKScene(fileNamed: "SettingsScene") as? SettingsScene
        self.settingsScene.viewController = self
        
        // Loading the Main Menu and showing!
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainScene") as? MainScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.viewController = self
                
                // Present the scene
                view.presentScene(scene)
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func musicVolumeChanged(sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "Music Volume")
        self.musicVolumeChanged = true
    }
    
    @IBAction func effectsVolumeChanged(sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "Effects Volume")
        self.effectsVolumeChanged = true
    }
}

