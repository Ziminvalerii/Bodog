//
//  GameViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 13.09.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseViewController<GamePresenterProtocol>,GameViewProtocol {
    
    let overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let intersitiialInfoView = RewardAdsView(frame: CGRect(x: 0, y: 0, width: 320, height: 330))

    @IBOutlet weak var crossButton: UIButton!
    
    
    let myView = UIView(frame: CGRect(x: 200, y: 200, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        showIntersitiialInfoView()
//        self.presenter.showAds(at: self)
        presenter.sendStake()
        player?.stop()

        if let scene = GKScene(fileNamed: "EnterScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! EnterScene? {
                
                // Copy gameplay related content over to the scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
                sceneNode.parentViewController = self
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
//                    view.showsFPS = true
//                    view.      = true
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

   
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
//        presenter.dissmiss(from: self)
        if presenter.isTraining {
            presenter.dissmiss(from: self)
        } else {
            presenter.disconectePeer()
        }
    }
    
    func showIntersitiialInfoView() {
        view.addSubview(overlay)
        intersitiialInfoView.center = overlay.center
        intersitiialInfoView.delegate = self
        self.view.addSubview(intersitiialInfoView)
        animateIn(intersitiialInfoView, overlay: overlay)
    }
    
    
    //MARK: - GameViewProtocol
    
    func dissmisSelf() {
//        presenter.dissmiss(from: self)
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
    }
    
    func updateSceneWithArray(secondPlayerScore: [RateModel]) {
        DispatchQueue.main.async {
            if let scene = (self.view as! SKView).scene as? RateScene {
                scene.secondPlayerScrore = secondPlayerScore
                scene.setViewShine()
                scene.showBackButton()
            }
        }
      
    }
    
    func updatePlayer(userInfo: UserInfo) {
        DispatchQueue.main.async {
            if let scene = (self.view as! SKView).scene as? RateScene {
                scene.player2View?.configure(plyerName: userInfo.userName, imageName: userInfo.iconMane)
                
            }
        }
    }
    
    func setStartButtonUserInteration(with value:Bool) {
        DispatchQueue.main.async {
            if let scene = (self.view as! SKView).scene as? EnterScene {
               let button = scene.childNode(withName: "playButton")
                button?.isUserInteractionEnabled = value
                
            }
        }
    }
    
    func setStakeLabel(with stake:Int) {
        DispatchQueue.main.async {
            if let scene = (self.view as! SKView).scene as? EnterScene {
               let label = scene.childNode(withName: "stakeLabel") as! SKLabelNode
                label.text = self.presenter.isTraining ? "Training\n Training cost: 500 coins" : "Your stake: \(stake)"
            }
        }
    }
}


extension GameViewController : InterstitialViewDelegate {
    func gotItButtonTapped() {
        animateOut(intersitiialInfoView, overlay: overlay) {
            DispatchQueue.main.async {
                self.presenter.showAds(at: self)
            }
        }
    }
    
    func crossButtonTapped() {
        animateOut(intersitiialInfoView, overlay: overlay) {
            if self.presenter.isTraining {
                self.presenter.dissmiss(from: self)
            } else {
                self.presenter.disconectePeer()
            }
        }
        
    }


}
