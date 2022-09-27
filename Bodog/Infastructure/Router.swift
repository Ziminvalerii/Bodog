//
//  Router.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit

protocol RouterProtocol {
    
    //MARK: - Properties
    var builder: BuilderProtocol {get set}
    //MARK: - Methods
    func presentTabBar() -> UIViewController
    func setUpTabBarVC() -> [UIViewController]
    func goToGameViewController(from vc: UIViewController, conectionManager: PeerContectionManager, adsManager: AdsManager, stake: Int?, words: [String]?, isTraining:Bool)
    func presentAvatarViewController(from vc:UIViewController, delegate: AvatarUpdate?)
    func dismissCurrentVC(_ vc: UIViewController)
    func presentShopVC(from vc: UIViewController, shop:ShopCases)
    func presentInstruction(from vc: UIViewController)

}

class Router : RouterProtocol {
    
    
    //MARK: - Properties
    var builder: BuilderProtocol
    
    //MARK: - Inizializator
    init(builder: BuilderProtocol) {
        self.builder = builder
    }
    
    //MARK: - Methods
    func presentTabBar() -> UIViewController {
        return builder.createTabBar(router: self)
    }
   
    
    func setUpTabBarVC() -> [UIViewController] {
        let connectionManager = PeerContectionManager()
        let adsManager = AdsManager()
        let firstVC = builder.setHomeViewController(router: self, conectionManager: connectionManager, adsManager: adsManager)
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named:"homeIcon")!, tag: 0)
        let secondVC = builder.setCreateViewController(router: self, conectionManager: connectionManager, adsManager: adsManager)
        secondVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(named:"createIcon")!, tag: 1)
        return [firstVC, secondVC]
    }
    
    func presentInstruction(from vc: UIViewController) {
        let goToVC = builder.createInstructionViewController(self)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
        
    }
    func goToGameViewController(from vc: UIViewController, conectionManager: PeerContectionManager, adsManager: AdsManager, stake: Int?, words: [String]?, isTraining:Bool) {
        let goToVC = builder.createGameViewContoller(self, conectionManager: conectionManager, adsManager: adsManager, stake: stake, words: words, isTraining: isTraining)
        goToVC.modalTransitionStyle = .coverVertical
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    
    func presentShopVC(from vc: UIViewController, shop:ShopCases) {
        let goToVC = builder.createShopViewController(self, shop: shop)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    
    func presentAvatarViewController(from vc:UIViewController, delegate: AvatarUpdate?) {
        let goToVC = builder.createAvatarViewController(self, delegate: delegate)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .overCurrentContext
        vc.present(goToVC, animated: true)
    }
    
    func dismissCurrentVC(_ vc: UIViewController) {
        vc.dismiss(animated: true)
    }
}
