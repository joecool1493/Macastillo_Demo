//
//  GameScene.swift
//  macastillo_demo
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    let spaceship = SKSpriteNode(imageNamed: "spaceship3")
    //let UFO = SKSpriteNode(imageNamed: "Shlorp")
    let enemy = SKSpriteNode(imageNamed: "CentralGrille")
    let jordee = SKSpriteNode(imageNamed: "Jordee2")
    let shelby = SKSpriteNode(imageNamed: "Shelby2")
    //let laser = SKSpriteNode(imageNamed: "laserBeam")
    var movableNode : SKNode?
    var spaceshipStartX : CGFloat = 0.0
    var spaceshipStartY : CGFloat = 0.0
    
   // let shootButton = SKSpriteNode(imageNamed: "button_shlorp")
    //let laserBeamSound = SKAction.playSoundFileNamed("laserBeamSound.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("YouAreWeak.mp3", waitForCompletion: false)
    let shlorpSound = SKAction.playSoundFileNamed("ShlorpSound.mp3", waitForCompletion: false)
    let jordeeSound = SKAction.playSoundFileNamed("JordeeSound.mp3", waitForCompletion: false)
    let shelbySound = SKAction.playSoundFileNamed("ShelbySound.mp3", waitForCompletion: false)
    
    let engineExhaust = SKEmitterNode(fileNamed: "engineExhaust.sks")
    
    var spaceshipHit = false
    var UFOHit = false
    var isPlaying = true
    
    var lives = 3
    var livesLabel = SKLabelNode(fontNamed: "Menlo")
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        playBackgroundMusic()
        
        livesLabel.text = "Gains: \(lives)"
        livesLabel.fontColor = SKColor.white
        livesLabel.fontSize = 75
        livesLabel.zPosition = 10
        livesLabel.horizontalAlignmentMode = .center
        livesLabel.verticalAlignmentMode = .center
        livesLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        addChild(livesLabel)
        
        spaceship.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.15)
        spaceship.setScale(0.1)
        spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spaceship.zPosition = 5
        spaceship.name = "spaceship"
        addChild(spaceship)
        
        engineExhaust?.position = CGPoint(x: 0.0, y: -(spaceship.size.height * 6))
        engineExhaust?.setScale(15)
        spaceship.addChild(engineExhaust!)
        
        //animateSpaceship()
        
      /*  shootButton.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.15)
        shootButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shootButton.setScale(1.5)
        shootButton.zPosition = 10
        shootButton.name = "shoot"
        addChild(shootButton) */
        
        addStarFields()
        //spawnUFO()
        
        let wait = SKAction.wait(forDuration: 2.1)
        let constantSpawning = SKAction.run {
            self.spawnUFO()
            //self.spawnEnemy()
        }
        let spawnSequence = SKAction.sequence([wait, constantSpawning])
        run(SKAction.repeatForever(spawnSequence))
        
        let wait2 = SKAction.wait(forDuration: 0.6)
        let constantSpawning2 = SKAction.run {
            //self.spawnUFO()
            self.spawnEnemy()
        }
        let spawnSequence2 = SKAction.sequence([wait2, constantSpawning2])
        run(SKAction.repeatForever(spawnSequence2))
        
        let wait3 = SKAction.wait(forDuration: 15.0)
        let constantSpawning3 = SKAction.run {
            //self.spawnUFO()
            self.spawnJordee()
        }
        let spawnSequence3 = SKAction.sequence([wait3, constantSpawning3])
        run(SKAction.repeatForever(spawnSequence3))
        
        let wait4 = SKAction.wait(forDuration: 20.5)
        let constantSpawning4 = SKAction.run {
            //self.spawnUFO()
            self.spawnShelby()
        }
        let spawnSequence4 = SKAction.sequence([wait4, constantSpawning4])
        run(SKAction.repeatForever(spawnSequence4))
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if (spaceship.contains(touchLocation)) {
                
                movableNode = spaceship
                spaceshipStartX = (movableNode?.position.x)! - touchLocation.x
                spaceshipStartY = (movableNode?.position.y)! - touchLocation.y
                
            }
            
          /*  if touchedNode.name == "shoot" {
                self.run(laserBeamSound)
                shootLaserBeam()
            } */
            
        }
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first, movableNode != nil {
            
            let location = touch.location(in: self)
            movableNode!.position = CGPoint(x: location.x + spaceshipStartX, y: location.y + spaceshipStartY)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ = touches.first, movableNode != nil {
            movableNode = nil
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ = touches.first {
            movableNode = nil
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        livesLabel.text = "GAINS: \(lives)"
        checkLives()
    }
    
    override func didEvaluateActions() {
        checkForCollisions()
    }
    
    func checkLives() {
        
        if lives <= 0 && isPlaying == true {
            
            isPlaying = false
            backgroundMusicPlayer.stop()
            
            let gameOverScene = GameOverScene(size: CGSize(width: 1536, height: 2048))
            gameOverScene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 0.75)
            
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
    }
    
    func checkForCollisions() {
        
        //Did UFO hit spaceship?
        enumerateChildNodes(withName: "UFO") {
            node, _ in
            let UFO = node as! SKSpriteNode
            
            if UFO.frame.intersects(self.spaceship.frame) {
                
                if self.spaceshipHit == false {
                    self.spaceshipHitByUFO()
                    print("UFO HIT SPACESHIP")
                } else if self.spaceshipHit == true {
                    return
                }
            }
            
        }
        
        //Did Enemy hit spaceship?
        enumerateChildNodes(withName: "enemy") {
            node, _ in
            let enemy = node as! SKSpriteNode
            
            if enemy.frame.intersects(self.spaceship.frame) {
                
                if self.spaceshipHit == false {
                    self.spaceshipHitByEnemy()
                    print("ENEMY HIT SPACESHIP")
                } else if self.spaceshipHit == true {
                    return
                }
            }
            
        }
        
        enumerateChildNodes(withName: "jordee") {
            node, _ in
            let jordee = node as! SKSpriteNode
            
            if jordee.frame.intersects(self.spaceship.frame) {
                
                if self.spaceshipHit == false {
                    self.spaceshipHitByJordee()
                    print("JORDEE HIT SPACESHIP")
                } else if self.spaceshipHit == true {
                    return
                }
            }
            
        }
        
        enumerateChildNodes(withName: "shelby") {
            node, _ in
            let shelby = node as! SKSpriteNode
            
            if shelby.frame.intersects(self.spaceship.frame) {
                
                if self.spaceshipHit == false {
                    self.spaceshipHitByShelby()
                    print("SHELBY HIT SPACESHIP")
                } else if self.spaceshipHit == true {
                    return
                }
            }
            
        }
        
        //Did Laser hit UFO?
        
       /*  enumerateChildNodes(withName: "laser") {
            node, _ in
            let laser = node as! SKSpriteNode
            
            if laser.frame.intersects(self.UFO.frame) {
                
                if self.UFOHit == false {
                    self.UFOHitByLaser()
                    print("LASER HIT UFO")
                } else if self.UFOHit == true {
                    return
                }
            }
            
        } */
        
        
        
        //CHALLENGE: COME BACK TO THIS TO SOLVE FOR LASER/UFO CONTACT. HINT: USE PHYSICS BODIES.
        
    }
    
    func animateSpaceship() {
        
        let rightMovement = SKAction.moveTo(x: self.size.width * 0.8, duration: 2.5)
        let leftMovement = SKAction.moveTo(x: self.size.width * 0.2, duration: 2.5)
        
        let sequence = SKAction.sequence([rightMovement, leftMovement])
        let animation = SKAction.repeatForever(sequence)
        
        spaceship.run(animation)
    }
    
    func spawnUFO() {
        
        let UFO = SKSpriteNode(imageNamed: "Shlorp")
        UFO.setScale(0.3)
        UFO.zPosition = 7
        UFO.name = "UFO"
        UFO.position = CGPoint(x: CGFloat.random(min: -200, max: self.size.width + 200), y: self.size.height + 200)
        addChild(UFO)
        
        let leftTwist = SKAction.rotate(byAngle: 3.14 / 8.0, duration: 0.5)
        let rightTwist = leftTwist.reversed()
        let fullTwist = SKAction.sequence([leftTwist, rightTwist])
        UFO.run(SKAction.repeatForever(fullTwist))
        
        let x = CGFloat.random(min: 0, max: self.size.width)
        let UFOMove = SKAction.move(to: CGPoint(x: x, y: -200), duration: 2.1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([UFOMove, remove])
        UFO.run(sequence)
    }
    
    func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "CentralGrille")
        enemy.setScale(1.1)
        enemy.zPosition = 7
        enemy.name = "enemy"
        enemy.position = CGPoint(x: CGFloat.random(min: -100, max: self.size.width + 200), y: self.size.height + 100)
        addChild(enemy)
        
        let leftTwist = SKAction.rotate(byAngle: 3.14 / 7.0, duration: 0.5)
        let rightTwist = leftTwist.reversed()
        let fullTwist = SKAction.sequence([leftTwist, rightTwist])
        enemy.run(SKAction.repeatForever(fullTwist))
        
        let x = CGFloat.random(min: 0, max: self.size.width)
        let enemyMove = SKAction.move(to: CGPoint(x: x, y: -100), duration: 1.1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([enemyMove, remove])
        enemy.run(sequence)
    }
    
    func spawnJordee() {
        
        let jordee = SKSpriteNode(imageNamed: "Jordee2")
        jordee.setScale(0.7)
        jordee.zPosition = 7.1
        jordee.name = "jordee"
        jordee.position = CGPoint(x: CGFloat.random(min: -50, max: self.size.width + 200), y: self.size.height + 50)
        addChild(jordee)
        
        let leftTwist = SKAction.rotate(byAngle: 3.14 / 6.0, duration: 0.5)
        let rightTwist = leftTwist.reversed()
        let fullTwist = SKAction.sequence([leftTwist, rightTwist])
        jordee.run(SKAction.repeatForever(fullTwist))
        
        let x = CGFloat.random(min: 0, max: self.size.width)
        let jordeeMove = SKAction.move(to: CGPoint(x: x, y: -100), duration: 1.7)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([jordeeMove, remove])
        jordee.run(sequence)
    }
    
    func spawnShelby() {
        
        let shelby = SKSpriteNode(imageNamed: "Shelby2")
        shelby.setScale(0.75)
        shelby.zPosition = 7.2
        shelby.name = "shelby"
        shelby.position = CGPoint(x: CGFloat.random(min: -25, max: self.size.width + 200), y: self.size.height + 25)
        addChild(shelby)
        
        let leftTwist = SKAction.rotate(byAngle: 3.14 / 5.0, duration: 0.5)
        let rightTwist = leftTwist.reversed()
        let fullTwist = SKAction.sequence([leftTwist, rightTwist])
        shelby.run(SKAction.repeatForever(fullTwist))
        
        let x = CGFloat.random(min: 0, max: self.size.width)
        let shelbyMove = SKAction.move(to: CGPoint(x: x, y: -100), duration: 1.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([shelbyMove, remove])
        shelby.run(sequence)
    }
    
    func spaceshipHitByUFO() {
        
        spaceshipHit = true
        
        let blinkTimes = 2.0
        let duration = 0.5
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() {
            [ weak self] in
            self?.spaceship.isHidden = false
            self?.spaceshipHit = false
        }
        
        spaceship.run(SKAction.sequence([blinkAction, setHidden]))
        run(shlorpSound)
        
        lives = lives + 1
    }
    
    func spaceshipHitByEnemy() {
        
        spaceshipHit = true
        
        let blinkTimes = 15.0
         let duration = 3.0
         let blinkAction = SKAction.customAction(withDuration: duration) {
         node, elapsedTime in
         let slice = duration / blinkTimes
         let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
         node.isHidden = remainder > slice / 2
         }
         let setHidden = SKAction.run() {
         [ weak self] in
         self?.spaceship.isHidden = false
         self?.spaceshipHit = false
         }
         
         spaceship.run(SKAction.sequence([blinkAction, setHidden]))
        run(explosionSound)
        
        lives = lives - 1
    }
    
    func spaceshipHitByJordee() {
        
        spaceshipHit = true
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() {
            [ weak self] in
            self?.spaceship.isHidden = false
            self?.spaceshipHit = false
        }
        
        spaceship.run(SKAction.sequence([blinkAction, setHidden]))
        run(jordeeSound)
        
        lives = lives - 4
    }
    
    func spaceshipHitByShelby() {
        
        spaceshipHit = true
        
        let blinkTimes = 7.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() {
            [ weak self] in
            self?.spaceship.isHidden = false
            self?.spaceshipHit = false
        }
        
        spaceship.run(SKAction.sequence([blinkAction, setHidden]))
        run(shelbySound)
        
        lives = lives - 5
    }
    
   /* func UFOHitByLaser() {
        
        UFOHit = true
        
        let blinkTimes = 15.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() {
            [ weak self] in
            self?.UFO.isHidden = false
            self?.UFOHit = false
        }
        
        UFO.run(SKAction.sequence([blinkAction, setHidden]))
        run(explosionSound)
        
        lives = lives + 1
    } */
    
    func shootLaserBeam() {
        
        let laser = SKSpriteNode(imageNamed: "laserBeam")
        
        laser.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        laser.setScale(0.1)
        laser.name = "laser"
        laser.position = spaceship.position
        
        addChild(laser)
        
        let moveY = size.height
        let moveDuration = 1.5
        
        let move = SKAction.moveBy(x: 0, y: moveY, duration: moveDuration)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        
        laser.run(sequence)
        
    }
    
    func addStarFields() {
        
        let starTexture = SKTexture(imageNamed: "spark.png")
        
        //EMITTER #1 Closer Stars
        let emitter = SKEmitterNode()
        emitter.particleTexture = starTexture
        emitter.particleBirthRate = 15
        emitter.particleLifetime = 45
        emitter.emissionAngle = CGFloat(90.0).degreesToRadians()
        emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        emitter.yAcceleration = -5
        emitter.particleSpeed = 30
        emitter.particleAlpha = 0.0
        emitter.particleAlphaSpeed = 0.5
        emitter.particleScale = 0.005
        emitter.particleScaleRange = 0.0075
        emitter.particleScaleSpeed = 0.01
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = SKColor.white
        emitter.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        emitter.zPosition = -4
        emitter.advanceSimulationTime(45)
        addChild(emitter)
        
        
        //EMITTER #2 More Distance Stars
        let emitter2 = SKEmitterNode()
        emitter2.particleTexture = starTexture
        emitter2.particleBirthRate = 10
        emitter2.particleLifetime = 180
        emitter2.emissionAngle = CGFloat(90.0).degreesToRadians()
        emitter2.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        emitter2.yAcceleration = 0
        emitter2.particleSpeed = 30
        emitter2.particleAlpha = 0.0
        emitter2.particleAlphaSpeed = 0.5
        emitter2.particleScale = 0.0005
        emitter2.particleScaleRange = 0.0005
        emitter2.particleScaleSpeed = 0.005
        emitter2.particleColorBlendFactor = 1.0
        emitter2.particleColor = SKColor.white
        emitter2.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        emitter2.zPosition = -5
        emitter2.advanceSimulationTime(180)
        addChild(emitter2)
        
    }
    
    func playBackgroundMusic() {
        
        do {
            
            let path = Bundle.main.path(forResource: "21Shots", ofType: "mp3")
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            backgroundMusicPlayer.volume = 0.5
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            
        } catch {
            print("error loading music")
        }
        
    }
    
}

extension CGFloat {
    public func degreesToRadians() -> CGFloat {
        
        let π = CGFloat(M_PI)
        return π * self / 180.0
        
    }
}

extension CGFloat {
    
    static func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
        
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
}
