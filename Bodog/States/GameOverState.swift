//
//  GameOverState.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 19.09.2022.
//

import GameplayKit
import SpriteKit

class GameOverState: GKState {

    
    //MARK: - Properties
    weak var gameManager: GameSceneManager?
    
    //MARK: -Initializer
    init(gameManager : GameSceneManager) {
        self.gameManager = gameManager
        super.init()
       
    }
    //MARK: - State Lifecycle
    override func didEnter(from previousState: GKState?) {
        guard let scene = gameManager?.scene else { return }
        gameManager?.isTipWasShown = false
        let sceneName = Scene.rate.rawValue
        let sceneToPresent = RateScene(fileNamed: sceneName)
        sceneToPresent?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1)
        sceneToPresent?.arrayScore = gameManager?.collectedWorlds
        if let gameScene = gameManager?.scene as? GameScene {
            sceneToPresent?.parentVC = gameScene.parentVC
            if let parentVC = gameScene.parentVC as? GameViewController {
                let array = gameManager!.collectedWorlds
                parentVC.presenter.conectionManager.send(message: .gameOver(array))
            }
            
        }
        transition.pausesIncomingScene = true
        transition.pausesOutgoingScene = false
        guard let sceneToPresent = sceneToPresent else { return }
        DispatchQueue.main.async {
            scene.view?.presentScene(sceneToPresent, transition: transition)
        }
    }

    
}
