//
//  MainMenuScene.swift
//  macastillo_demo
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MaxMainMenu")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.addChild(background)
    }
    
    func mainMenuTapped() {
        
        let myScene = GameScene(size: size)
        myScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
        view?.presentScene(myScene, transition: reveal)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainMenuTapped()
    }
    
}
