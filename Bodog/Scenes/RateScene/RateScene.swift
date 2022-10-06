//
//  RateScene.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import SpriteKit

class RateScene: SKScene {
    //MARK: - Properties
    weak var parentVC: UIViewController?
    var rateScreenView = RateScreenView()
    var isWinner: Bool?
    var player2View: PlayerView?
    var player1View: PlayerView?
    var arrayScore: [RateModel]? {
        didSet {
            rateScreenView.firstPlayerItems = arrayScore ?? []
        }
    }
    
    var secondPlayerScrore:[RateModel]? {
        didSet {
            let label = scene?.childNode(withName: "waitingLabel")
            
            if secondPlayerScrore == nil {
                label?.run(SKAction.fadeIn(withDuration: 1))
            } else {
                label?.run(SKAction.fadeOut(withDuration: 1))
                setViewShine()
                showBackButton()
            }
            rateScreenView.secondPlayerItems = secondPlayerScrore ?? []
        }
    }
    //MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            if (parentVC as? GameViewController)?.presenter.isTraining ?? false {
                showBackButton()
            }
            hideSecondsPlayer()
            rateScreenView.frame = CGRect(x: 0, y: view.frame.midY/2 , width: view.bounds.width /*- 20*/, height: 500)
            self.scene?.view?.addSubview(rateScreenView)
            secondPlayerScrore = (parentVC as? GameViewController)?.presenter.secondPlayerScore
            player1View = PlayerView(frame: CGRect(x: 40, y: view.frame.midY/2 - 16*3, width: view.bounds.size.width/2 - 24, height: 40))
            player1View!.configure(plyerName: Defaults.userName, imageName: "person\(Defaults.imageIndex)")
            player2View = PlayerView(frame: CGRect(x: (view.bounds.size.width/2 - 24) + 16 + 14, y: view.frame.midY/2 - 16*3, width:view.bounds.size.width/2 - 24, height: 40))
            if let userInfo = (parentVC as? GameViewController)?.presenter.userInfo {
                player2View!.configure(plyerName: userInfo.userName, imageName: userInfo.iconMane)
            } else {
                player2View!.configure(plyerName: "player2", imageName: "person1")
            }
            self.scene?.view?.addSubview(player1View!)
            self.scene?.view?.addSubview(player2View!)
        }
        
    }
    //MARK: - UI Methods
    func hideSecondsPlayer() {
        if let parentVC = parentVC as? GameViewController {
            if parentVC.presenter.isTraining {
                player2View?.isHidden = true
                rateScreenView.setHiddenSecondPlayer()
                let label = scene?.childNode(withName: "waitingLabel") as? SKLabelNode
                label?.text = "Training is over"
            }
        }
    }
    
    func showErrorLabel(with title: String) {
        let label = scene?.childNode(withName: "winLabel") as? SKLabelNode
        label?.position = CGPoint(x: 0, y: -319)
        label?.isHidden = false
        label?.text = title
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

    func showBackButton() {
        if let parentVC = parentVC as? GameViewController {
            parentVC.crossButton.isHidden = false
        }
    }
    
    func setViewShine() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            if let player1Scrore = rateScreenView.firstPlayerTotalScore, let player2Score = rateScreenView.secondPlayerTotalScore {
                let stake = (parentVC as? GameViewController)?.presenter.stake
                let label = scene?.childNode(withName: "winLabel") as? SKLabelNode
                if player1Scrore > player2Score {
                    
                    player1View?.doGlowAnimation(withColor: UIColor.yellow, withEffect: .big)
                    label?.isHidden = false
                    label?.text = "You won: +\(stake?.description ?? "")"
                    
                    if Defaults.coins != nil && isWinner == nil {
                        isWinner = true
                        Defaults.coins! += stake ?? 0
                    }
                } else {
                    player2View?.doGlowAnimation(withColor: UIColor.yellow, withEffect: .big)
                    label?.isHidden = false
                    label?.text = "You lost: -\(stake?.description ?? "")"
                    
                    
                    if Defaults.coins != nil && isWinner == nil {
                        isWinner = false
                        Defaults.coins! -= stake ?? 0
                    }
                }
            }
        }
    }
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode?, rect:CGSize) {
        let scalingFactor = min(rect.width / (labelNode?.frame.width ?? 40), rect.height / (labelNode?.frame.height ?? 40))
        labelNode?.fontSize *= scalingFactor
    }
    
}
