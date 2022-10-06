//
//  EnterScene.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 14.09.2022.
//

import SpriteKit

class EnterScene: SKScene {
    
    //MARK: _ Properties
    weak var parentViewController : UIViewController?
    
    //MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        let stakeLabel = scene?.childNode(withName: "stakeLabel") as? SKLabelNode
        if let parentVC = parentViewController as? GameViewController {
            if parentVC.presenter.isTraining {
                stakeLabel?.attributedText = getStakeAttrStr(str: "Training\nTraining cost: 500 coins")
            } else {
                stakeLabel?.text = "Your stake: "
            }
        }
        
    }
    //MARK: - UI
    private func getStakeAttrStr(str:String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: str)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: str.count)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([.foregroundColor : UIColor.white, .font : UIFont(name: "Copperplate Bold", size: 48.0)!], range: range)
        return attrString
    }
    
    
    private func getAttrStr(str:String)-> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: str)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: str.count)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([.foregroundColor : UIColor.black, .font : UIFont(name: "Copperplate Bold", size: 32)], range: range)
        return attrString
    }

    func showErrorLabel() {
        let label = scene?.childNode(withName: "errorLabel") as? SKLabelNode
        label?.position = CGPoint(x: 0, y: -319)
        label?.isHidden = false
        let atrStr = getAttrStr(str: "You couldn't start the game because you didnt have enought money")
        label?.attributedText = atrStr
//        label?.horizontalAlignmentMode = .center
        label?.verticalAlignmentMode = .center
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
    
}

//MARK: - Button Responder
extension EnterScene : ButtonResponder {
    func buttonTriggered(_ node: ButtonNode) {
        let identifier = node.indentifier

        switch identifier {
        case .playButton :
            let parentVC = parentViewController as? GameViewController
            if parentVC?.presenter.canStartGame() ?? false {
                if parentVC!.presenter.isTraining {
                    if Defaults.coins! < 500 {
                        showErrorLabel()
                        return
                    } else {
                        Defaults.coins! -= 500
                    }
                }
                
                let sceneName = Scene.game.rawValue
                let sceneToPresent = GameScene(fileNamed: sceneName)
                sceneToPresent?.parentVC = parentViewController
                sceneToPresent?.scaleMode = .aspectFill
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 2)
                //            SKTransition.crossFade(withDuration: 4)
                
                transition.pausesIncomingScene = false
                transition.pausesOutgoingScene = false
                guard let sceneToPresent = sceneToPresent else { return }
                DispatchQueue.main.async {
                    self.view?.presentScene(sceneToPresent, transition: transition)
                }
                
                print("dddkdk")
            } else {
                showErrorLabel()
            }

        default: break
        }
    }


}
