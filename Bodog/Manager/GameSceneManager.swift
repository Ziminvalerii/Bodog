//
//  GameSceneManager.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 14.09.2022.
//

import SpriteKit
import GameplayKit


class GameSceneManager: GameSceneProtocol, TimerDelegate {
    
    //MARK: - Properties
    weak var scene: SKScene?
    var isTipWasShown: Bool = false
    var touchables: [Touchable] = [Touchable]()
    var updatables: [Updatable] = [Updatable]()
    var collectedWorlds = [RateModel]()
    var score: Int = 0 {
        didSet {
            let scoreView = scene?.childNode(withName: "scoreView")
            let scoreLabel = scoreView?.childNode(withName: "scoreLabel") as? SKLabelNode
            scoreLabel?.text = "YOUR SCORE: \(score)"
        }
    }
    
    var word: [String] = ["account"]
    var timeManager:TimerManager
    var stateMachine: GKStateMachine?
    //MARK: -Initializer
    required init?(with scene : SKScene ) {
        self.scene = scene
        
        guard let scene = self.scene else { return nil }
        timeManager = TimerManager(seconds: 60, at: scene)
        timeManager.delegate = self
    }
    
    //MARK: - Setting Up UI
    func setUpLabelMoving(with text:String?) {
        let label = scene?.childNode(withName: "enterText") as? SKLabelNode
        label?.position = CGPoint(x: 0, y: -319)
        label?.isHidden = false
        label?.text = text
        label?.run(SKAction.fadeIn(withDuration: 0))
        let action = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1)
        let fadeAction = SKAction.fadeOut(withDuration: 2)
        label?.run(action) {
            label?.position = CGPoint(x: 0, y: -319)
            label?.isHidden = true
        }
        label?.run(fadeAction) {
            
        }
    }
    
    func setUpLabelWithSeconds(seconds: String) {
        let label = scene?.childNode(withName: "timerLabel") as? SKLabelNode
        label?.text = seconds
    }
    
    func timerHasEndedCountDown() {
        moveAllWorldSpriteBack {
            let worldNodes = self.scene?.children.filter({$0.name == "wordSpite"}) as! [WordSlotSprite]
            worldNodes.forEach({$0.shouldAcceptTouches = false})
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.stateMachine?.enter(GameOverState.self)
        }
        
        
    }
    
    
    func getScore(by word: String) -> Int {
        var score:Int
        switch word.count {
        case 3 :
            score = 100
        case 4 :
            score = 250
        case 5 :
            score = 500
        case 6:
            score = 1000
        case 7:
            score = 2000
        default :
            score = 0
        }
        return score
    }
    
    
    func showTip() {
            var str: String?
            for i in self.word {
                if !self.collectedWorlds.contains(where: {$0.word.lowercased() == i}) {
                     str = i
                    break
                }
            }
            print(str)
            guard let str = str else {return}
                for i in str {
                    self.showLetter(with: i)
                }
    }
    
    func moveAllWorldSpriteBack(complition: (() -> Void)? = nil) {
        var world:String = ""
        let busyEmptyNodes = scene?.children.filter({$0.name == "emptyNode" && ($0 as! EmptyNode).isBusy}) as! [EmptyNode]
        for i in busyEmptyNodes {
            world += i.busyNode?.char ?? ""
            if let firstPosition = i.busyNode?.firstPosition {
                i.busyNode?.moveTo(firstPosition, with: 0.25) {
                    complition?()
                }
                i.busyNode?.firstPosition = nil
                i.isBusy = false
                i.busyNode = nil
            }
        }
        let isWordExists = isCorrect(word: world.lowercased())
        print("word \(world) exists : \(isWordExists)")
        if isWordExists && world.count > 2 && !collectedWorlds.contains(where: {$0.word == world}) {
            let soundAction = SKAction.playSoundFileNamed("success.mp3", waitForCompletion: false)
            scene?.run(soundAction)
            let curScore = getScore(by: world)
            collectedWorlds.append(RateModel(score: curScore, word: world))
            score += curScore
            setUpLabelMoving(with: "\(world) (+\(curScore))")
        } else {
            let soundAction = SKAction.playSoundFileNamed("erorr.mp3", waitForCompletion: false)
            var str : String
            if collectedWorlds.contains(where: {$0.word == world}) {
                str = "You have already used this word"
            } else if world.count <= 2 {
                str = "The letters count should be more that 2"
            } else {
                str = "no word has been found"
            }
            setUpLabelMoving(with: str)
            scene?.run(soundAction)
        }
        
        
    }
    
    func mixWorldSprite() {
        let worldNodes = scene?.children.filter({$0.name == "wordSpite" && ($0 as! WordSlotSprite).firstPosition == nil}) as! [WordSlotSprite]
        let mixButton = scene?.childNode(withName: ButtonNodesIdentifier.mixButton.rawValue)
        mixButton?.isUserInteractionEnabled = false
        var lastPositionArray = [CGPoint]()
        for i in worldNodes {
            lastPositionArray.append(i.position)
        }
        
        lastPositionArray.shuffle()
        
        for i in 0 ... worldNodes.count - 1 {
            worldNodes[i].moveTo(lastPositionArray[i], with: 0.4) {
                mixButton?.isUserInteractionEnabled = true
            }
            worldNodes[i].firstPosition = nil
        }
        
    }
    
    //MARK: - Private Methods
    private func isCorrect(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    private func showLetter(with char: Character) {
        let emptyNodes = scene?.children.filter({$0.name == "emptyNode"}) as! [EmptyNode]
        let worldNodes = scene?.children.filter({$0.name == "wordSpite" && ($0 as! WordSlotSprite).firstPosition == nil && ($0 as! WordSlotSprite).char == char.uppercased().description}) as! [WordSlotSprite]
        let wordNode = worldNodes.first
        guard let wordNode = wordNode else {return}
        let serialqueue = DispatchQueue(label: "serialQueue")
            for i in 0...emptyNodes.count - 1 {
                if !emptyNodes[i].isBusy {
                        wordNode.moveTo(emptyNodes[i].position, with: 0.35) {
                        }
                    emptyNodes[i].isBusy = true
                    emptyNodes[i].busyNode = wordNode
                    return
                }
            }
    }
    
}


//MARK: - Touches
extension GameSceneManager: TouchDelegate {
    func touchesBegan(_ node: WordSlotSprite) {
        let enterButton = scene?.childNode(withName: ButtonNodesIdentifier.enterButton.rawValue)
        enterButton?.isUserInteractionEnabled = false
        let emptyNodes = scene?.children.filter({$0.name == "emptyNode"}) as? [EmptyNode]
        guard let emptyNodes = emptyNodes else { return }
        let serialqueue = DispatchQueue(label: "serialQueue")
        if node.firstPosition == nil {
            serialqueue.async {
                for emptyNode in emptyNodes {
                    if !emptyNode.isBusy {
                        DispatchQueue.main.async {
                            node.moveTo(emptyNode.position, with: 0.35) {
                                enterButton?.isUserInteractionEnabled = true
                            }
                            
                        }
                        emptyNode.isBusy = true
                        emptyNode.busyNode = node
                        return
                    }
                }
            }
        } else {
            node.moveTo(node.firstPosition!, with: 0.35){
                enterButton?.isUserInteractionEnabled = true
            }
            node.firstPosition = nil
            serialqueue.sync {
                for i  in 0 ... emptyNodes.count - 1 {
                    if emptyNodes[i].intersects(node) {
                        emptyNodes[i].isBusy = false
                        emptyNodes[i].busyNode = nil
                    }
                }
                for i  in 0 ... emptyNodes.count - 1 {
                    if i < emptyNodes.count - 1 {
                        if emptyNodes[i+1].isBusy && !emptyNodes[i].isBusy {
                            emptyNodes[i+1].busyNode?.moveTo(emptyNodes[i].position, with: 0.2){
                                enterButton?.isUserInteractionEnabled = true
                            }
                            let temp = emptyNodes[i+1].busyNode
                            emptyNodes[i+1].busyNode = nil
                            emptyNodes[i+1].isBusy = false
                            emptyNodes[i].isBusy = true
                            emptyNodes[i].busyNode = temp
                        }
                    }
                }
            }
        }
    }
    
    
}
