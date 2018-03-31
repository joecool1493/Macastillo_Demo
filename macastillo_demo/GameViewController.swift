//
//  GameViewController.swift
//  macastillo_demo
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var shakeAudioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
let skView = self.view as! SKView
skView.showsFPS = true
skView.showsNodeCount = true
skView.ignoresSiblingOrder = true
scene.scaleMode = .aspectFill
skView.presentScene(scene)




        
       /* if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        } */
 
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let randomNumber = arc4random_uniform(2)
            if randomNumber == 0 {
                do {
                    let path = Bundle.main.path(forResource: "Macastando", ofType: "mp3")
                    shakeAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
                    shakeAudioPlayer?.volume = 0.8
                    shakeAudioPlayer?.prepareToPlay()
                    shakeAudioPlayer?.play()
                } catch {
                    print("error loading audio file")
                }
            } else {
                do {
                    let path = Bundle.main.path(forResource: "Macastillo", ofType: "mp3")
                    shakeAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
                    shakeAudioPlayer?.volume = 0.8
                    shakeAudioPlayer?.prepareToPlay()
                    shakeAudioPlayer?.play()
                } catch {
                    print("error loading audio file")
                }
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
