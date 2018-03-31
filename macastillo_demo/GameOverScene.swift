//
//  GameOverScene.swift
//  macastillo_demo
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
/*CHALLENGE: IMPLEMENT CODE TO DETERMINE IF PLAYER WINS. AND INCLUDE A WIN SCREEN. PLAYER GETTING A CERTAIN AMOUNT OF POINTS?*/
        
        run(SKAction.playSoundFileNamed("smallMuscles.mp3", waitForCompletion: false))
        
        
        let background = SKSpriteNode(imageNamed: "MaxGameOver")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.addChild(background)
        
        let wait = SKAction.wait(forDuration: 4.5)
        let block = SKAction.run {
            
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.75)
            self.view?.presentScene(myScene, transition: reveal)
        }
        
        self.run(SKAction.sequence([wait, block]))
        
    }
}
