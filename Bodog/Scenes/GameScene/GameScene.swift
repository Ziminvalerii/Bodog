//
//  GameScene.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 13.09.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Properties
    weak var parentVC: UIViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    var gameManager: GameSceneManager!
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(gameManager: gameManager!),
        GameOverState(gameManager: gameManager!)
        ])

    
    //MARK: -Scene Lifecycle
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        gameManager = GameSceneManager(with: self)
        gameManager.stateMachine = stateMachine
        stateMachine.enter(PlayingState.self)

        
    }
    
    override func didMove(to view: SKView) {
        if let parentVC = parentVC as? GameViewController {
            parentVC.crossButton.isHidden = true
        }
    }
    

    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.touchables.forEach { toucheble in
            toucheble.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    private func containsTouches(node: SKNode, touches: Set<UITouch>) -> Bool {
        guard let scene = node.scene else { return false }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === node || touchedNode.inParentHierarchy(node)
        }
    }
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

//MARK: -Button Responder 
extension GameScene : ButtonResponder {
    func buttonTriggered(_ node: ButtonNode) {
        let id = node.indentifier
        switch id {
        case .mixButton :
            gameManager.mixWorldSprite()
        case .enterButton :
            gameManager.moveAllWorldSpriteBack()
        case .tip:
            if !gameManager.isTipWasShown && Defaults.tips! >= 0 {
            Defaults.tips! -= 1
                gameManager.isTipWasShown = true
                gameManager.showTip()
            } else if Defaults.tips! <= 0 {
                gameManager.setUpLabelMoving(with: "You dont have enought tips")
            } else {
               gameManager.setUpLabelMoving(with: "You already used tip")
           }
        default: break
        }
    }
    
    
}
