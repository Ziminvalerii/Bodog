//
//  GamePresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit
import AVFoundation

protocol ResultProtocol {
    func showResultView(isWinner:Bool)
    
}

protocol GameViewProtocol : AnyObject {
    func updateSceneWithArray(secondPlayerScore : [RateModel])
    func updatePlayer(userInfo: UserInfo)
    func setStakeLabel(with stake:Int)
    func dissmisSelf()
}


protocol GamePresenterProtocol : AnyObject, PeerDisconectedProtocol {
    var userInfo: UserInfo? { get }
    var conectionManager: PeerContectionManager { get }
    var secondPlayerScore : [RateModel]? { get }
    var words : [String]? { get }
    var stake: Int? { get }
    var isTraining: Bool { get }
    init(view: GameViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager,adsManager: AdsManager, isTraining:Bool)
    func dissmiss(from vc: UIViewController)
    func sendStake()
    func showAds(at vc:UIViewController)
    func disconectePeer()
    func canStartGame() -> Bool 
}


class GamePresenter : GamePresenterProtocol {
    //MARK: -Properties
    var userInfo: UserInfo?
    var conectionManager: PeerContectionManager
    weak var view: GameViewProtocol?
    private var router: RouterProtocol
    var secondPlayerScore : [RateModel]?
    var adsManager: AdsManager
    var words : [String]?
    var isTraining: Bool
    var stake: Int? {
        didSet {
            if stake != nil {
                view?.setStakeLabel(with: stake!)
            }
        }
    }
    //MARK: -Initializer
    required init(view: GameViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager, adsManager: AdsManager, isTraining:Bool) {
        self.view = view
        self.router = router
        self.conectionManager = conectionManager
        self.adsManager = adsManager
        self.isTraining = isTraining
        self.conectionManager.disconectedProtocol = self
      
    }
    
    func canStartGame() -> Bool {
        return (stake ?? 0) <= (Defaults.coins ?? 0)
    }
    
    func disconectePeer() {
        conectionManager.disconect()
    }
    
    func sendStake() {
        if stake != nil && words != nil {
            conectionManager.send(message: .startGame(StartGameModel(stake: stake!, world: words!)))
        }
    }
    
    func showAds(at vc:UIViewController) {
        
//            try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
//            try? AVAudioSession.sharedInstance().setActive(false)
//      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
            self.adsManager.showRewardedAds(at: vc) { reward in
                
                if reward == nil {
//                    self.dissmiss(from: vc)
                    self.disconectePeer()
                    self.dissmiss(from: vc)
                }
            }
        }
    }
    
    func dissmiss(from vc: UIViewController) {
        router.dismissCurrentVC(vc)
    }
    
    
    
}

//MARK: - PeerDisconectedProtocol
extension GamePresenter : PeerDisconectedProtocol {
    func disconected() {
        view?.dissmisSelf()
    }
    
    func recieved(message: MessageType) {
        switch message {
        case .startGame(let startGameModel) :
            self.stake = startGameModel.stake
            self.words = startGameModel.world
            break;
        case .gameOver(let array):
            secondPlayerScore = array
            view?.updateSceneWithArray(secondPlayerScore: array)
        case .user(let userInfo):
            self.userInfo = userInfo
            view?.updatePlayer(userInfo: userInfo)
        }
    }
    
    
}
