//
//  PlayingState.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 14.09.2022.
//

import GameplayKit
import SpriteKit

class PlayingState: GKState {
    
    //MARK: - Propeties
    weak var gameManager: GameSceneManager?
    
    lazy var backgroundAudio: SKAudioNode = {
      let audio = SKAudioNode(fileNamed: "backgroundMusic.wav")
      audio.autoplayLooped = true
      return audio
    }()
    
    
    //MARK: -Initializer
    init(gameManager : GameSceneManager) {
        self.gameManager = gameManager
        super.init()
        if let scene = gameManager.scene {
        }
    }

    //MARK: - State Lifecycle
    override func didEnter(from previousState: GKState?) {
        guard let scene = gameManager?.scene else { return }
        gameManager?.timeManager.startTimer()
        spawnCharSlots()
                
        let coinsNode = scene.childNode(withName: "coins") as! SKSpriteNode
        let coinsCountLabel = coinsNode.childNode(withName: "coinsCount") as? SKLabelNode
        adjustLabelFontSizeToFitRect(labelNode: coinsCountLabel, rect: CGSize(width: 25, height: 50))
        coinsCountLabel?.text = Defaults.coins?.description
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let scene = scene as? GameScene {
                if let parentVC = scene.parentVC as? GameViewController {
                    parentVC.presenter.conectionManager.send(message: .user(UserInfo(userName: Defaults.userName, iconMane: "person\(Defaults.imageIndex)")))
                    if let wordsArr = parentVC.presenter.words {
                        self.gameManager!.word = wordsArr
                        self.spawnTextsSlots()
                    }
                }
            }
        }
    }
    
    
    //MARK: - Setting Up UI
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode?, rect:CGSize) {
        let scalingFactor = min(rect.width / (labelNode?.frame.width ?? 40), rect.height / (labelNode?.frame.height ?? 40))
        labelNode?.fontSize *= scalingFactor

    }
    
    func spawnCharSlots() {
        guard let scene = gameManager?.scene else {return }
        spawnSprites(yPos: -scene.size.height/6) { index in
            let emptyNode = EmptyNode()
            emptyNode.name = "emptyNode"
            return emptyNode
        }
    }
    
    func createCharSlot() -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "charSlot")
        sprite.size = CGSize(width: 64, height: 64)
        sprite.zPosition = 5
        return sprite
    }
    
    func spawnTextsSlots() {
        guard let scene = gameManager?.scene else {return }
        let str = gameManager!.word[0].uppercased().shuffled()
        let spacebetween = (scene.size.width - 64 * 7)/(7*2)
//        let characters = Array(str)
        spawnSprites(yPos: -scene.size.height/3) { index in
            let wordSprite = createTextSlot()
            wordSprite.name = "wordSpite"
            wordSprite.touchDelegate = gameManager
            wordSprite.zPosition = 9
            wordSprite.char = str[index].description
            gameManager?.touchables.append(wordSprite)
            return wordSprite
        }
    }
    
    func spawnSprites(yPos: CGFloat, complition : (_ index: Int) -> SKSpriteNode) {
        guard let scene = gameManager?.scene else {return }
        let spacebetween = (scene.size.width - 64 * 7)/(7*2)
        var xPos:CGFloat = -scene.size.width/2 + 64*1.5 + spacebetween
        for i in 0 ... 6 {
            let sprite = complition(i)
            sprite.position =  CGPoint(x: xPos, y: yPos)
            
            xPos += sprite.size.width + spacebetween
            scene.addChild(sprite)
        }
        
    }
    
    func createTextSlot() -> WordSlotSprite {
        let wordSlot = WordSlotSprite()
        //        wordSlot.position = CGPoint(x: 0, y: -size.height/4)
        wordSlot.zPosition = 5
        return wordSlot
    }
    
}
