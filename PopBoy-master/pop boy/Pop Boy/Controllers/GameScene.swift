import SpriteKit
import Foundation
import CoreGraphics


// gerador de numero aleatorio dentro do intervalo de tamanho da tela
extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UInt32.max))
  }
  
  static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }
}

enum MovementDir {
    case top, bot, left, right
}

class GameScene: SKScene, SceneHandler {

    // Public properties
    var previousScene: SKScene?
    weak var viewController: GameViewController!
    
    // Public static properties related to the screen
    public static var LargeSize: CGFloat = 900
    public static var HeightSize: CGFloat = 740
    public static var BoundLeft: CGFloat = -450
    public static var BoundRight: CGFloat = 450
    public static var BoundBottom: CGFloat = 270
    public static var BoundHigher: CGFloat = -270

    // Game Scene components nodes
    private var base: SKSpriteNode!
    private var knob: SKSpriteNode!
    private var lollipop: SKSpriteNode!
    
    private var buttonPause: SKSpriteNode!
    private var backgroundMusic: SKAudioNode?
    private var audioEffects: SKAudioNode?
    
    public let worldNode = SKNode()
    private var worldNodeSpawned = false
    
    // Variable to control the touched components
    private var selectedNodes:[UITouch:SKSpriteNode] = [:] //dictionary
    private var movementDir: MovementDir = .top
    
    // Spawn Related
    private var ant = Ant()
    private var cockroach = Cockroach()
    private var spawnDelayAnt: TimeInterval = 4
    private var spawnDelayCockroach: TimeInterval = 4

    private var queen = Queen()
    private let queenFlag = SKSpriteNode(imageNamed: "flagQueen")
    
    
    
    // Controle das fases
    var upFase: TimeInterval = 0
    var Fase: Int = 0
    var controle: Bool = false
    
    //poup
    private var blur: SKSpriteNode!
    private var backgroundPopup: SKSpriteNode!
    private var buttonSettings: SKSpriteNode!
    private var buttonQuit: SKSpriteNode!
    private var buttonReplay: SKSpriteNode!
    
    private var labelYourScore: SKLabelNode!
    private var labelMessage: SKLabelNode!
    private var labelMessageShadow: SKLabelNode!

    
    //aux variables
    private var velocityChar: CGFloat = 0.1
    private var xDist: CGFloat = 0.0
    private var yDist: CGFloat = 0.0
    private var collision: Bool = false
    private var actionButton: String = "" //"Resume" or "Replay"
    
    // variaveis para controle de tempo entre os updates
    private var lastUpdateTime: TimeInterval = 0
    private var dt: TimeInterval = 0
    
    // Private properties
    private var currentScore: Int = 0
    
    private var labelScore: SKLabelNode?
    
    private var lastFrameTime: TimeInterval = 0
    private var timeElapsed: TimeInterval = 0
    private var isFirstFrame: Bool = true
    private var isUpdatePaused: Bool = false
    
    private var idleAnimation: SKTexture?
    private var animationList: [SKTexture] = []

    override func didMove(to view: SKView) {
        
        self.labelScore = self.childNode(withName: "Label Score") as! SKLabelNode?

        queenFlag.name = "flagQueen"
        queenFlag.position = CGPoint( x: self.queen.position.x, y: GameScene.BoundHigher)
        queenFlag.alpha = 0
        self.worldNode.addChild(queenFlag)
        
        // showing the base node
        base =  (self.childNode(withName: "base") as? SKSpriteNode)!
        let texture1 = SKTexture(imageNamed: "base")
        base.texture = texture1
        base.alpha = 0.4
        base.zPosition = 1
        
        knob =  (self.childNode(withName: "knob") as? SKSpriteNode)!
        let texture2 = SKTexture(imageNamed: "knob")
        knob.texture = texture2
        knob.alpha = 0.6
        knob.zPosition = 1
        
        // Pop Boy related nodes
        
        self.lollipop =  (self.childNode(withName: "lolipop") as? SKSpriteNode)!
        self.lollipop.name = "lolipop"
        let idleTexture = SKTexture(imageNamed: "idle0000")
        self.idleAnimation = idleTexture // Initial animation - Idle
        self.lollipop?.texture = self.idleAnimation

        
        buttonPause = (self.childNode(withName: "buttonPause") as? SKSpriteNode)!
        let imgPause = UIImage(named: "Pause Icon")
        let texPause = SKTexture(image: imgPause!)
        self.buttonPause.texture = texPause

        //adding the elements of popup
        blur =  (self.childNode(withName: "blur") as? SKSpriteNode)!
        backgroundPopup =  (self.childNode(withName: "background_popup") as? SKSpriteNode)!
        buttonQuit =  (self.childNode(withName: "background_popup/buttonQuit") as? SKSpriteNode)!
        buttonReplay =  (self.childNode(withName: "background_popup/buttonReplay") as? SKSpriteNode)!
        
        labelYourScore = (self.childNode(withName: "background_popup/labelYourScore") as? SKLabelNode)!
        labelMessage = (self.childNode(withName: "background_popup/labelMessage") as? SKLabelNode)!
        labelMessageShadow = (self.childNode(withName: "background_popup/labelMessage Shadow") as? SKLabelNode)!
        
        //nodes of the enemies
        if (!self.worldNodeSpawned) {
            self.addChild(self.worldNode)
            self.worldNode.name = "enemies"
            self.worldNodeSpawned = true
        }
        
        hidePopup()
        
        // colocando rato no meio da tela
        queen.position = CGPoint(x: 0, y: -500)
        queen.name = "queen"
        queen.size = CGSize(width: 128, height: 128)
        
        let queenTexture = SKTexture(imageNamed: "rainha0000")
        let queenTexture2 = SKTexture(imageNamed: "rainha0001")
        let queenAnimated = [queenTexture, queenTexture2]
        
        queen.run(SKAction.repeatForever(SKAction.animate(with: queenAnimated, timePerFrame: 0.05)), withKey: "moveQueen")
        
        if (!queen.isQueenDefined) {
            self.worldNode.addChild(self.queen)
            self.queen.isQueenDefined = true
        }
        
        
        // Setting up the mobs
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { self.ant.spawnAnt(gameScene: self)
            },
            SKAction.wait(forDuration: spawnDelayAnt)]))
            , withKey: "spawnAnt")
        
        // Setting up the Background Music
        
        self.backgroundMusic = self.childNode(withName: "Main Music") as? SKAudioNode
        self.audioEffects = self.childNode(withName: "Audio Effects") as? SKAudioNode
        
        var musicVolume = UserDefaults.standard.string(forKey: "Music Volume") ?? "0.5"
        var effectsVolume = UserDefaults.standard.string(forKey: "Effects Volume") ?? "0.5"
        
        self.backgroundMusic?.run(SKAction.changeVolume(to: Float(musicVolume)!, duration: 0))
        
        self.audioEffects?.run(SKAction.changeVolume(to: Float(effectsVolume)!, duration: 0))
    
        
        
        // Setting up the Animation Array for the Player
        
        self.animationList = []
        
        for i in 0 ..< 10 {
            //let image = UIImage(named: "run000" + String(i))
            let runTexture = SKTexture(imageNamed: "run000" + String(i))
            self.animationList.append(runTexture)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ){
            let location = touch.location(in: self)

            if let node = self.atPoint(location) as? SKSpriteNode {
                // adding nodes into the dictionary
                
                if (node.name == "buttonPause") {
                    selectedNodes[touch] = node
                    
                    self.audioEffects?.run(SKAction.play())
                    
                
                    actionButton = "Resume"
                }
                else if node.name == "buttonSettings" {
                    selectedNodes[touch] = node
                    
                    loadSettingsScene()
                }
                else if node.name == "buttonQuit" || node.name == "Home Icon" {
                    selectedNodes[touch] = node
                    self.worldNode.isPaused = false
                    
                    loadMainScene()
                }
                else if node.name == "buttonReplay" || node.name == "Play Icon" {
                    selectedNodes[touch] = node
                    
                    self.audioEffects?.run(SKAction.play())
                }
                
            }

        }

    }
    
    
    /// Method for calculating the score by a interval of time and updating the score's label.
    ///
    /// - Parameter currentTime: The current System Time
    private func calculateTheScoreByTime(currentTime: TimeInterval) {
        
        if !isUpdatePaused {
            
            self.timeElapsed += (currentTime - self.lastFrameTime)
        
            if self.timeElapsed >= 1.0 {
                self.currentScore += 1
                self.timeElapsed = 0
                
                // Updating the score label...
                self.labelScore?.text = String(self.currentScore)
            }
        }
    }
    
    
    /// Method for adding bonuses on the score by an amount and updating the score's label.
    ///
    /// - Parameter amountBonus: The amount of bonus in Integer
    private func addBonusPoints(amountBonus: Int) {
        self.currentScore += amountBonus
        self.labelScore?.text = String(self.currentScore)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let vector = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
            let angle = atan2(vector.dy, vector.dx)
            

            let lenght: CGFloat = base.frame.size.height / 2 // the bound of the ball at the base
            
            xDist = sin(angle - 1.57079633) * lenght //radians
            yDist = cos(angle - 1.57079633) * lenght //radians
            
            let rect: CGRect = base.frame
            
            if (rect.contains(location)) {
                knob.position = location
            }
            else {
                knob.position = CGPoint(x: base.position.x - xDist, y: base.position.y + yDist)
            }

            
            // Setting animation facing to the Right side
            if (location.x > self.base.position.x) {
                
                self.lollipop.removeAction(forKey: "moveLeft")
                
                if (self.movementDir != .right) {
                    self.lollipop.run(SKAction.repeatForever(SKAction.animate(with: self.animationList, timePerFrame: 0.05)), withKey: "moveRight")
                    self.movementDir = .right
                }

                if self.lollipop.xScale < 0 {
                    self.lollipop.xScale = self.lollipop.xScale * -1
                }
                
            }
            // Setting animation facing to the Left side
            else if (location.x < self.base.position.x) {
                
                self.lollipop.removeAction(forKey: "moveRight")

                if (self.movementDir != .left) {
                    self.lollipop.run(SKAction.repeatForever(SKAction.animate(with: self.animationList, timePerFrame: 0.05)), withKey: "moveLeft")
                    self.movementDir = .left
                }

                if self.lollipop.xScale > 0 {
                    self.lollipop.xScale = self.lollipop.xScale * -1
                }
            }
            // Setting animation facing to the Right side
            else if (location.y > self.base.position.y) {
                
                self.lollipop.removeAction(forKey: "moveLeft")

                if (self.movementDir != .right) {
                    self.lollipop.run(SKAction.repeatForever(SKAction.animate(with: self.animationList, timePerFrame: 0.05)), withKey: "moveRight")
                    self.movementDir = .right
                }
      
                if self.lollipop.xScale < 0 {
                    self.lollipop.xScale = self.lollipop.xScale * -1
                }
                
            }
            // Setting animation facing to the Left side
            else if (location.y < self.base.position.y) {
                
                self.lollipop.removeAction(forKey: "moveRight")

                if (self.movementDir != .left) {
                    self.lollipop.run(SKAction.repeatForever(SKAction.animate(with: self.animationList, timePerFrame: 0.05)), withKey: "moveLeft")
                    self.movementDir = .left
                }

                if self.lollipop.xScale > 0 {
                    self.lollipop.xScale = self.lollipop.xScale * -1
                }
            }
                

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //remove the item from dictionary
        for touch in touches {
            if selectedNodes[touch] != nil {
                if selectedNodes[touch]?.name == "buttonPause" {
                    //stop the movement
                    xDist = 0.0
                    yDist = 0.0
                    
                    self.movementDir = .top // Resetting the animation
                    self.showPopup("Pause")
                    self.pauseGame()
                }
                else if selectedNodes[touch]?.name == "buttonReplay" || selectedNodes[touch]?.name == "Play Icon" {
                    self.hidePopup()
                    self.unpauseGame()
                    
                    if actionButton == "Replay" {
                        self.worldNode.removeAllChildren()
                        currentScore = 0
                        labelScore?.text = "0"
                        
                        queen.position = CGPoint(x: 0, y: -500)
                        queen.name = "queen"
                        queen.size = CGSize(width: 128, height: 128)
                        self.worldNode.addChild(queen)
                        
                        self.worldNode.addChild(queenFlag)
                        // spawns and speed of enemies
                        ant.speedAnt = 80 // t = S x V -> t = (HeightSize or LargeSize) x speedAnt (s)
                        self.spawnDelayAnt = 4
                        
                        self.spawnDelayCockroach = 4
                        cockroach.speedCockroach = 80 // t = S / V -> t = (HeightSize or LargeSize) x speedCockroach (s)
                        
                        self.queen.speedQueen = 50
                        self.queen.isQueenDefined = false
                        
                        
                        // Controle das fases
                        self.upFase = 0
                        self.Fase = 0
                        self.controle = false
                        
                    }
                }
            }
            else { // If there's nothing... We'll move the knob!
                //make the knob movement to the base position
                let move:SKAction = SKAction.move(to: base.position, duration: 0.2)
                move.timingMode = .easeOut
                knob.run(move)
                
                //stop the movement
                xDist = 0.0
                yDist = 0.0
                
                // Stopping the animation
                self.lollipop.texture = self.idleAnimation
                self.movementDir = .top // Resetting the animation
                
                self.lollipop.removeAction(forKey: "moveRight")
                self.lollipop.removeAction(forKey: "moveLeft")
            }
            
            selectedNodes[touch] = nil
        }
    }

    override func update(_ currentTime: TimeInterval) {
        
        if !self.isUpdatePaused {
            
            // changing the position of the object
            if(((lollipop.position.x - xDist * velocityChar * 0.5) > GameScene.BoundLeft) && ((lollipop.position.x - xDist * velocityChar * 0.5) < GameScene.BoundRight))
            {
                lollipop.position.x = lollipop.position.x - xDist * velocityChar * 0.5
                
            }
            
            if(((lollipop.position.y + yDist * velocityChar * 0.5) > (GameScene.BoundHigher+8)) && ((lollipop.position.y + yDist * velocityChar * 0.5) < (GameScene.BoundBottom-8)))
            {
                lollipop.position.y = lollipop.position.y + yDist * velocityChar * 0.5
                
            }
            
            if lastUpdateTime > 0 {
                // dt é o tempo decorrente desde a ultima atualizacao
                dt = currentTime - lastUpdateTime
                upFase += dt
            }
            else { dt = 0 }
            lastUpdateTime = currentTime
            
            if(upFase > 10)
            {
                upFase = 0
                Fase += 1
                
                if(Fase == 1)
                {
                    run(SKAction.repeatForever(
                        SKAction.sequence([SKAction.run() { self.cockroach.spawnCockroach(gameScene: self)
                            },
                                           SKAction.wait(forDuration: spawnDelayCockroach)]))
                        , withKey: "spawnCockroach")
                }
                
                if((Fase%3) != 0 && (Fase%9) != 0 && Fase < 13)
                {
                    ant.speedAnt += 20
                    cockroach.speedCockroach += 20
                }
                
                if((Fase%9) != 0)
                {
                    spawnDelayAnt *= 0.8
                    spawnDelayCockroach *= 0.8
                }
                
                if((Fase%3) == 0)
                {
                    controle = true
                    if(Fase <= 12)
                    {self.queen.speedQueen += 20}
                    queenFlag.alpha = 1
                }
                
                else{ controle = false }
            }
            
            if(controle)
            {
                // coordenada destino, coordenada do pirulito
                let location = CGPoint(x: lollipop.position.x, y: lollipop.position.y)
                self.queen.move(sprite: self.queen, location: location, dt: self.dt, queenFlag: self.queenFlag)
                
                if(queen.position.y > (GameScene.BoundHigher-100)) { queenFlag.alpha = 0 }
            }
            else
            {
                let location = CGPoint(x: 0, y: -500)
                self.queen.move(sprite: queen, location: location, dt: self.dt, queenFlag: self.queenFlag)
            }

            if !self.isFirstFrame { // We'll jump the 1st frame to get immediately the lastTime of the present delta frametime
                
                // Calculating the Score by time
                self.calculateTheScoreByTime(currentTime: currentTime)
            }
            else {
                self.isFirstFrame = false
            }
            
            self.lastFrameTime = currentTime
            
            collision = checkCollisions()
            
            if collision == true { // game over
                //make the knob movement to the base position
                knob.position = base.position
                
                //stop the movement
                xDist = 0.0
                yDist = 0.0
                
                //pause the game
                self.pauseGame()
                
                //open the pop game over
                actionButton = "Replay"
                showPopup("Game Over")
            }
        }
    }
    
    
    
    /// Method for checking (and updating) the best score.
    ///
    /// - Returns: True if the player hits the actual best score or False.
    private func checkBestScore() -> Bool{

        let score = UserDefaults.standard.string(forKey: "Score") ?? ""
        
        if score == "" {
            UserDefaults.standard.set(self.currentScore, forKey: "Score")
            return true;
        }
        else if Int(score)! < self.currentScore {
            UserDefaults.standard.set(self.currentScore, forKey: "Score")
            return true;
        }
        
        return false;
    }

    /// Method that removes lolipop from the screen
    ///
    /// - Parameter lolipop: <#lolipop description#>
    func enemyHit(_ lolipop: SKSpriteNode) {
        lolipop.position = CGPoint(x: 0, y: 0)
    }
    
    
    /// Method that check all the time if the lolipop touches in some enemy
    func checkCollisions() -> Bool {
        var xDist: Float = 0.0
        var yDist: Float = 0.0
        
        var res: Bool = false
        
        var hitants: [SKSpriteNode] = []
        self.worldNode.enumerateChildNodes(withName: "ant") { node, _ in
            let aux_ant = node as! SKSpriteNode
            if aux_ant.frame.insetBy(dx: 20, dy: 20).intersects(
                self.lollipop.frame) {
                hitants.append(aux_ant)
            }
        }
        
        for aux_ant in hitants {
            enemyHit(lollipop)
            
            xDist = Float(lollipop.position.x) - Float(aux_ant.position.x)
            yDist = Float(lollipop.position.y) - Float(aux_ant.position.y)
            if( xDist < 10 || yDist < 10)
            {res = true}
        }
        
        var hitcockroachs: [SKSpriteNode] = []
        self.worldNode.enumerateChildNodes(withName: "cockroach") { node, _ in
            let aux_cockroach = node as! SKSpriteNode
            if aux_cockroach.frame.insetBy(dx: 30, dy: 30).intersects(
                self.lollipop.frame) {
                hitcockroachs.append(aux_cockroach)
            }
        }
        
        for aux_cockroach in hitcockroachs {
            enemyHit(lollipop)
            xDist = Float(lollipop.position.x) - Float(aux_cockroach.position.x)
            yDist = Float(lollipop.position.y) - Float(aux_cockroach.position.y)
            if( xDist < 5 || yDist < 5)
            {res = true}
        }
        

        var hitqueens: [SKSpriteNode] = []
        self.worldNode.enumerateChildNodes(withName: "queen") { node, _ in
            let aux_queen = node as! SKSpriteNode
            if node.frame.insetBy(dx: 30, dy: 30).intersects(
                self.lollipop.frame) {
                hitqueens.append(aux_queen)
            }
        }
        
        for aux_queen in hitqueens {
            enemyHit(lollipop)
            res = true
        }
        
        return res
    }
    
    
    
    
    
    /// Method for opening the dialog by two types: gameover or pause
    ///
    /// - Parameters:
    ///   - message: show in the labelMessage "Game Over" or "Pause"
    func showPopup(_ message: String){
        self.blur.isHidden = false
        self.backgroundPopup.isHidden = false
        self.buttonPause.isHidden = true
        self.movementDir = .top // Resetting the animation
        
        self.labelMessage.text = message
        self.labelMessageShadow.text = message
        
        if message == "Game Over"{
            //buttonReplay.texture =
            
            // Checking if it's a new record
            if self.checkBestScore() == true {
                self.labelYourScore.text = "NEW RECORD: " + String(self.currentScore)
            }
            else {
                self.labelYourScore.text = "Your Score: " + String(self.currentScore)
            }
            
        }
        else if message == "Pause"{
            //buttonReplay.texture =
            
            let score = UserDefaults.standard.string(forKey: "Score") ?? ""
            
            if score != "" {
                self.labelYourScore.text = "Your Score: " + String(self.currentScore)
            }
            else {
                self.labelYourScore.text = "Your Score: 0"
            }
        }
        
    }
    
    
    /// <#Description#>: hide the popup in the scene
    func hidePopup(){
        self.blur.isHidden = true
        self.backgroundPopup.isHidden = true
        self.buttonPause.isHidden = false
    }
    
    
    /// <#Description#>: change to the MainScene
    func loadMainScene() {
        self.view?.presentScene(self.previousScene!)
    }
    
    
    /// <#Description#>: change to the SettingsScene
    func loadSettingsScene() {
        
        if let scene = SKScene(fileNamed: "SettingsScene") as? SettingsScene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            scene.viewController = self.viewController
            scene.previousScene = self
            
            // Present the scene
            self.view?.presentScene(scene)
        }
        
    }
    
    func pauseGame(){
        self.worldNode.isPaused = true
        self.action(forKey: "spawnAnt")?.speed = 0.0
        self.action(forKey: "spawnCockroach")?.speed = 0.0
        self.action(forKey: "moveAnt")?.speed = 0.0
        self.action(forKey: "moveCockroach")?.speed = 0.0
        self.action(forKey: "moveQueen")?.speed = 0.0
        
        self.isUpdatePaused = true
    }
    
    
    func unpauseGame(){
        self.worldNode.isPaused = false
        self.action(forKey: "spawnAnt")?.speed = 1.0
        self.action(forKey: "spawnCockroach")?.speed = 1.0
        self.action(forKey: "moveAnt")?.speed = 1.0
        self.action(forKey: "moveCockroach")?.speed = 1.0
        self.action(forKey: "moveQueen")?.speed = 1.0
        
        self.isUpdatePaused = false
    }
}
