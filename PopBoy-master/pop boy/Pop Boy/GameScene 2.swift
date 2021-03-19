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

class GameScene: SKScene, SceneHandler {

    // Public properties
    var previousScene: SKScene?
    weak var viewController: GameViewController!

    //nodes
    private var base: SKSpriteNode!
    private var knob: SKSpriteNode!
    private var lolipop: SKSpriteNode!
    //private var buttonDance: SKSpriteNode!
    private var buttonPause: SKSpriteNode!
    private var backgroundMusic: SKAudioNode?
    private var audioEffects: SKAudioNode?
    
    private let worldNode = SKNode()
    private var worldNodeSpawned = false
    
    private var selectedNodes:[UITouch:SKSpriteNode] = [:] //dictionary

    // screen dimensions
    private var largeSize: CGFloat = 900
    private var heightSize: CGFloat = 740
    private var BoundLeft: CGFloat = -450
    private var BoundRight: CGFloat = 450
    private var BoundBottom: CGFloat = 270
    private var BoundHigher: CGFloat = -270
    
    // spawns and speed of enemies
    private var speedAnt: Int = 100 // t = S x V -> t = (heightSize or largeSize) x speedAnt (s)
    private var spawnDelayAnt: Int = 1
    
    private var spawnDelayCockroach: Int = 1
    private var speedCockroach: Int = 100 // t = S / V -> t = (heightSize or largeSize) x speedCockroach (s)
    
    private let speedMouse: CGFloat = 100
    private let mouse = SKSpriteNode(imageNamed: "mouse")
    private var isRatDefined = false
    
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

    override func didMove(to view: SKView) {
        
        self.labelScore = self.childNode(withName: "Label Score") as! SKLabelNode?

        let size = CGRect(x: 0, y: 0, width: 1024, height: 768)//self.view!.frame.size
        
        var playableRect: CGRect
        
        // configuracoes de tela
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        // estabelecendo limites da tela
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        
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
        
        lolipop =  (self.childNode(withName: "lolipop") as? SKSpriteNode)!
        lolipop.name = "lolipop"
        
        buttonPause = (self.childNode(withName: "buttonPause") as? SKSpriteNode)!
        let imgSettings = UIImage(named: "Settings Icon")
        let texSettings = SKTexture(image: imgSettings!)
        self.buttonPause.texture = texSettings
        
        //buttonDance = (self.childNode(withName: "buttonDance") as? SKSpriteNode)!
        
        //adding the elements of popup
        blur =  (self.childNode(withName: "blur") as? SKSpriteNode)!
        backgroundPopup =  (self.childNode(withName: "background_popup") as? SKSpriteNode)!
        buttonSettings =  (self.childNode(withName: "background_popup/buttonSettings") as? SKSpriteNode)!
        buttonQuit =  (self.childNode(withName: "background_popup/buttonQuit") as? SKSpriteNode)!
        buttonReplay =  (self.childNode(withName: "background_popup/buttonReplay") as? SKSpriteNode)!
        
        labelYourScore = (self.childNode(withName: "background_popup/labelYourScore") as? SKLabelNode)!
        labelMessage = (self.childNode(withName: "background_popup/labelMessage") as? SKLabelNode)!
        labelMessageShadow = (self.childNode(withName: "background_popup/labelMessage/labelMessage Shadow") as? SKLabelNode)!

        //nodes of the enemies
        if (!self.worldNodeSpawned) {
            self.addChild(worldNode)
            worldNode.name = "enemies"
            self.worldNodeSpawned = true
        }
        
        hidePopup()
        
        // colocando rato no meio da tela
        mouse.position = CGPoint(x: 400, y: 400)
        mouse.name = "rat"
        //worldNode.addChild(mouse)
        
        if (!self.isRatDefined) {
            worldNode.addChild(mouse)
            self.isRatDefined = true
        }
        
        
        // criando ants a cada 1 segundo
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { self.spawnAnt()
            },
            SKAction.wait(forDuration: 1.0)]))
            , withKey: "spawnAnt")

        // criando cockroachs a cada 1 segundo
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { self.spawnCockroach()
                },
                               SKAction.wait(forDuration: 1.0)]))
            , withKey: "spawnCockroach")
        
        // Setting up the Background Music
        
        self.backgroundMusic = self.childNode(withName: "Main Music") as? SKAudioNode
        self.audioEffects = self.childNode(withName: "Audio Effects") as? SKAudioNode
        
        let musicVolume = UserDefaults.standard.float(forKey: "Music Volume") ?? 0.5
        let effectsVolume = UserDefaults.standard.float(forKey: "Effects Volume") ?? 0.5
        
        self.backgroundMusic?.run(SKAction.changeVolume(to: musicVolume, duration: 0))
        self.backgroundMusic?.autoplayLooped = true
        self.backgroundMusic?.run(SKAction.play())
        
        self.audioEffects?.run(SKAction.changeVolume(to: effectsVolume, duration: 0))
        
    }
    
    /// Method for spawning Ants
    func spawnAnt() {
        
        let ant = SKSpriteNode(imageNamed: "ant")
        ant.name = "ant"
        
        // posicao da formiga em comum com a flag
        var randomPos: CGFloat
        
        //duracao do movimento da formiga
        var duration: TimeInterval
        
        // cria numero randomico para escolher por qual lado da tela vai surgir a ant
        let rand = Int(arc4random_uniform(4))
        switch rand {
        case 0:
            // spawn na parte inferior da tela
            randomPos = CGFloat.random( min: BoundLeft, max: BoundRight)
            ant.position = CGPoint( x: randomPos, y: -heightSize )
            worldNode.addChild(ant)
            
            let flag = SKSpriteNode(imageNamed: "flagHigher")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Higher"))
            flag.position = CGPoint( x: randomPos, y: BoundHigher)
            worldNode.addChild(flag)
            
            duration = TimeInterval(Int(heightSize)/speedAnt)
            let actionMove = SKAction.moveTo(y: heightSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/8)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 1:
            // spawn na parte superior da tela
            randomPos = CGFloat.random( min: BoundLeft, max: BoundRight)
            ant.position = CGPoint( x: randomPos, y: heightSize )
            worldNode.addChild(ant)
            
            let flag = SKSpriteNode(imageNamed: "flagBottom")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Bottom"))
            flag.position = CGPoint( x: randomPos, y: BoundBottom)
            worldNode.addChild(flag)
            
            duration = TimeInterval(Int(heightSize)/speedAnt)
            let actionMove = SKAction.moveTo(y: -heightSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/8)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 2:
            // spawn na esquerda da tela
            randomPos = CGFloat.random( min: BoundHigher, max: BoundBottom)
            ant.position = CGPoint( x: -largeSize, y: randomPos )
            worldNode.addChild(ant)
            
            let flag = SKSpriteNode(imageNamed: "flagLeft")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Left"))
            flag.position = CGPoint( x: BoundLeft, y: randomPos)
            worldNode.addChild(flag)
            
            duration = TimeInterval(Int(largeSize)/speedAnt)
            let actionMove = SKAction.moveTo(x: largeSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/16)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
            
        default:
            // spawn na direita da tela
            randomPos = CGFloat.random( min: BoundHigher, max: BoundBottom)
            ant.position = CGPoint( x: largeSize, y: randomPos )
            worldNode.addChild(ant)
            
            let flag = SKSpriteNode(imageNamed: "flagRight")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Right"))
            flag.position = CGPoint( x: BoundRight, y: randomPos)
            worldNode.addChild(flag)
            
            duration = TimeInterval(Int(largeSize)/speedAnt)
            let actionMove = SKAction.moveTo(x: -largeSize, duration: duration)
            let actionRemove = SKAction.removeFromParent()
            
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/16)), actionRemove]))
            ant.run(SKAction.sequence([actionMove, actionRemove]))
        }
    }
    
    
    /// Method for spawning Cockroaches
    func spawnCockroach() {
        
        let cockroach = SKSpriteNode(imageNamed: "cockroach")
        cockroach.name = "cockroach"
        
        var duration: TimeInterval
        
        // amplitude do movimento da cockroach
        let rand2 = CGFloat(arc4random_uniform(20)*10)
        
        // posicao da formiga em comum com a flag
        var randomPos: CGFloat
        
        // cria numero randomico para escolher por qual lado da tela vai surgir a cockroach
        let rand: Int = Int(arc4random_uniform(4))
        switch rand {
        case 0:
            // spawn na parte inferior da tela
            randomPos = CGFloat.random( min: BoundLeft, max: (BoundRight - rand2))
            cockroach.position = CGPoint( x: randomPos, y: -heightSize )
            worldNode.addChild(cockroach)
            
            let flag = SKSpriteNode(imageNamed: "flagHigher")
            flag.name = "flag"
            let modColor = SKAction.setTexture(SKTexture(imageNamed: "flag2Higher"))
            flag.position = CGPoint( x: randomPos, y: BoundHigher)
            worldNode.addChild(flag)
            
            duration = TimeInterval(Int(heightSize)/speedCockroach)
            let actionMove =    SKAction.sequence([
                SKAction.moveBy(x: CGFloat(rand2), y:(heightSize*2)/3, duration: duration/3),
                SKAction.moveBy(x: CGFloat(-rand2), y:(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:(heightSize*2)/3, duration: duration/3)
                ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            flag.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(duration/8)), modColor , SKAction.wait(forDuration: TimeInterval(duration/8)), actionRemove]))
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 1:
            // spawn na parte superior da tela
            cockroach.position = CGPoint(
                x: CGFloat.random(
                    min: BoundLeft,
                    max: CGFloat(BoundRight - rand2)),
                
                y: heightSize
            )
            worldNode.addChild(cockroach)
            
            duration = TimeInterval(Int(heightSize)/speedCockroach)
            let actionMove = SKAction.sequence([
                SKAction.moveBy(x: CGFloat(rand2), y:-(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:-(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(rand2), y:-(heightSize*2)/6, duration: duration/6),
                SKAction.moveBy(x: CGFloat(-rand2), y:-(heightSize*2)/6, duration: duration/6)
                ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        case 2:
            // spawn na esquerda da tela
            cockroach.position = CGPoint(
                x:  -largeSize,
                y: CGFloat.random(
                    min: BoundHigher,
                    max: CGFloat(BoundBottom - rand2))
            )
            worldNode.addChild(cockroach)
            
            duration = TimeInterval(Int(largeSize)/speedCockroach)
            let actionMove =
                SKAction.sequence([
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: 1800/6, y: CGFloat(-rand2), duration: duration/6)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
            
        default:
            // spawn na direita da tela
            cockroach.position = CGPoint(
                x:  largeSize,
                y:  CGFloat.random(
                    min: BoundHigher,
                    max: CGFloat(BoundBottom - rand2))
            )
            worldNode.addChild(cockroach)
            
            duration = TimeInterval(Int(largeSize)/speedCockroach)
            let actionMove =
                SKAction.sequence([
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(rand2), duration: duration/6),
                    SKAction.moveBy(x: -1800/6, y: CGFloat(-rand2), duration: duration/6)
                    ])
            
            let actionRemove = SKAction.removeFromParent()
            // ant percorre a tela e depois é destruida
            cockroach.run(SKAction.sequence([actionMove, actionRemove]))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ){
            let location = touch.location(in: self)

            if let node = self.atPoint(location) as? SKSpriteNode {
                // adding nodes into the dictionary
                if (node.name == "knob") {
                    selectedNodes[touch] = node
                    
                }
                else if (node.name == "buttonPause") {
                    selectedNodes[touch] = node
                    
                    self.audioEffects?.run(SKAction.play())
                    
                
                    actionButton = "Resume"
                }
                else if(node.name == "buttonDance") {
                    selectedNodes[touch] = node

                }
                else if node.name == "buttonSettings" {
                    selectedNodes[touch] = node
                    
                    loadSettingsScene()
                }
                else if node.name == "buttonQuit" {
                    selectedNodes[touch] = node

                    loadMainScene()
                }
                else if(node.name == "buttonCatch") {
                    selectedNodes[touch] = node
                    selectedNodes[touch]?.color = UIColor.yellow
                }

                else if node.name == "buttonReplay" {
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
    
    // funçao que descreve movimento do mouse
    func move(sprite: SKSpriteNode) {
        
        // coordenada destino, futuramente deve ser a coordenada do pirulito
        let location = CGPoint(x: lolipop.position.x, y: lolipop.position.y)
        
        //movimento ocorre enquanto a coordenada destino nao for a mesma atual
        if(mouse.position.x != location.x || location.y != mouse.position.y) {
            // distancia x e y entre destino e local atual
            let offset = CGPoint(x: location.x - mouse.position.x, y: location.y - mouse.position.y)
            
            // calculo da hipotenusa
            let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
            
            // seno e cosseno o triangulo
            let direction = CGPoint(x: offset.x / CGFloat(length),
                                    y: offset.y / CGFloat(length))
            
            // velocidade do movimento
            let velocity = CGPoint(x: direction.x * speedMouse,
                                   y: direction.y * speedMouse)
            
            // deslocamento = (tempo entre as atualizacoes) x (velocidade determinada)
            let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                       y: velocity.y * CGFloat(dt))
            // efetuando deslocamento na posicao do mouse
            sprite.position = CGPoint(
                x: mouse.position.x + amountToMove.x,
                y: mouse.position.y + amountToMove.y)
            
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if let node = selectedNodes[touch] {
                if node.name == "knob"{
                    //action of knob
                    let vector = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                    let angle = atan2(vector.dy, vector.dx)
                        
                    let degrees = angle * CGFloat(180 / Double.pi) // converting
                        
                    let lenght: CGFloat = base.frame.size.height / 2 // the bound of the ball at the base
                        
                    xDist = sin(angle - 1.57079633) * lenght //radians
                    yDist = cos(angle - 1.57079633) * lenght //radians
                        
                    let rect: CGRect = base.frame
                    
                    if rect.contains(location){
                        knob.position = location
                    }
                    else{
                        knob.position = CGPoint(x: base.position.x - xDist, y: base.position.y + yDist)
                    }
                        
                    // changing the angle of object
                    //lolipop.zRotation = (angle - 1.57079633)
                }
//                else if node.name == "buttonDance" {
//                    //action of button
//
//                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //remove the item from dictionary
        for touch in touches {
            if selectedNodes[touch] != nil {
                if selectedNodes[touch]?.name == "knob"{
                    //make the knob movement to the base position
                    let move:SKAction = SKAction.move(to: base.position, duration: 0.2)
                    move.timingMode = .easeOut
                    knob.run(move)
                        
                    //stop the movement
                    xDist = 0.0
                    yDist = 0.0
                }
                else if selectedNodes[touch]?.name == "buttonPause" {
                    //stop the movement
                    xDist = 0.0
                    yDist = 0.0
                    
                    self.showPopup("Pause")
                    self.pauseGame()
                }
                else if selectedNodes[touch]?.name == "buttonReplay" {
                    self.hidePopup()
                    
                    if actionButton == "Replay" {
                        //replay()
                        worldNode.removeAllChildren() //remove all the enemies from the screen
                        currentScore = 0
                        labelScore?.text = "0"
                        
                    }
                    
                    self.unpauseGame()
                }
//                else if selectedNodes[touch]?.name == "buttonDance"{
//                    selectedNodes[touch]?.color = UIColor.red
//                }
                
                //remove
                selectedNodes[touch] = nil
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !self.isUpdatePaused {
            
            // changing the position of the object
            lolipop.position = CGPoint(x: lolipop.position.x - xDist * velocityChar,
                                      y: lolipop.position.y + yDist * velocityChar)

            // funcao responssavel pelo movimento do rato
            if lastUpdateTime > 0 {
            // dt é o tempo decorrente desde a ultima atualizacao
            dt = currentTime - lastUpdateTime
            } else {
            dt = 0 }
            lastUpdateTime = currentTime
            //move(sprite: mouse)

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
        var res: Bool = false
        
        var hitants: [SKSpriteNode] = []
        worldNode.enumerateChildNodes(withName: "ant") { node, _ in
            let aux_ant = node as! SKSpriteNode
            if aux_ant.frame.intersects(
                self.lolipop.frame) {
                hitants.append(aux_ant)
            }
        }
        
        for aux_ant in hitants {
            enemyHit(lolipop)
            res = true
        }
        
        var hitcockroachs: [SKSpriteNode] = []
        worldNode.enumerateChildNodes(withName: "cockroach") { node, _ in
            let aux_cockroach = node as! SKSpriteNode
            if node.frame.insetBy(dx: 20, dy: 20).intersects(
                self.lolipop.frame) {
                hitcockroachs.append(aux_cockroach)
            }
        }
        
        for aux_cockroach in hitcockroachs {
            enemyHit(lolipop)
            res = true
        }
        
        var hitmouses: [SKSpriteNode] = []
        worldNode.enumerateChildNodes(withName: "mouse") { node, _ in
            let aux_mouse = node as! SKSpriteNode
            if node.frame.insetBy(dx: 20, dy: 20).intersects(
                self.lolipop.frame) {
                hitmouses.append(aux_mouse)
            }
        }
        
        for aux_mouse in hitmouses {
            enemyHit(lolipop)
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
        
        self.labelMessage.text = message
        self.labelMessageShadow.text = message
        
        if message == "Game Over"{
            //buttonReplay.texture =
            
            // Checking if it's a new record
            if self.checkBestScore() == true {
                self.labelYourScore.text = "Your new Record: " + String(self.currentScore)
            }
            else {
                self.labelYourScore.text = "Your Score: " + String(self.currentScore)
            }
        }
        else if message == "Pause"{
            //buttonReplay.texture =
            
            let score = UserDefaults.standard.string(forKey: "Score") ?? ""
            
            if score != "" {
                self.labelYourScore.text = "Best Score: " + String(score)
            }
            else {
                self.labelYourScore.text = "Best Score: 0"
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
        
        if let scene = SettingsScene(fileNamed: "SettingsScene") as? SettingsScene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            scene.viewController = self.viewController
            scene.previousScene = self
            
            // Present the scene
            self.view?.presentScene(scene)
        }
        
    }
    
    func pauseGame(){
        worldNode.isPaused = true
        self.action(forKey: "spawnAnt")?.speed = 0.0
        self.action(forKey: "spawnCockroach")?.speed = 0.0
        
        self.isUpdatePaused = true
    }
    
    
    func unpauseGame(){
        worldNode.isPaused = false
        self.action(forKey: "spawnAnt")?.speed = 1.0
        self.action(forKey: "spawnCockroach")?.speed = 1.0
        
        self.isUpdatePaused = false
    }
}
