//
//  Builder.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import Foundation
import UIKit


protocol BuilderProtocol {
    func setHomeViewController(router: RouterProtocol,conectionManager: PeerContectionManager,adsManager: AdsManager) -> HomeViewController
    func setCreateViewController(router: RouterProtocol, conectionManager: PeerContectionManager,adsManager: AdsManager) -> CreateGameViewController
    func createTabBar( router: RouterProtocol)-> UITabBarController
    func createGameViewContoller(_ router: RouterProtocol, conectionManager: PeerContectionManager, adsManager: AdsManager, stake: Int?, words: [String]?, isTraining: Bool) -> GameViewController
    func createAvatarViewController(_ router: RouterProtocol, delegate: AvatarUpdate?) -> AvatarViewController
    func createShopViewController(_ router: RouterProtocol, shop: ShopCases) -> ShopViewController
    func createInstructionViewController(_ router: RouterProtocol) -> InstructionViewController
    func createSettingsViewController(_ router: RouterProtocol) -> SettingsViewController
    }


class Builder: BuilderProtocol {
    func createSettingsViewController(_ router: RouterProtocol) -> SettingsViewController {
        let vc = SettingsViewController.instantiateMyViewController()
        vc.presenter = SettingsPresenter(view: vc, router: router)
        return vc
    }
    
    func createInstructionViewController(_ router: RouterProtocol) -> InstructionViewController {
        let vc = InstructionViewController.instantiateMyViewController()
        vc.presenter = InstructionPresenter(view: vc, router: router)
        return vc
    }
    
    func setHomeViewController(router: RouterProtocol,conectionManager: PeerContectionManager,adsManager: AdsManager) -> HomeViewController {
        let vc = HomeViewController.instantiateMyViewController()
        vc.presenter = HomePresenter(view: vc, router: router, conectionManager: conectionManager, adsManager: adsManager)
        return vc
    }
    
    func setCreateViewController(router: RouterProtocol, conectionManager: PeerContectionManager,adsManager: AdsManager) -> CreateGameViewController {
        let vc = CreateGameViewController.instantiateMyViewController()
        vc.presenter = CreateGamePresenter(view: vc, router: router, conectionManager: conectionManager, adsManager: adsManager)
        return vc
    }
    
    func createTabBar(router: RouterProtocol) -> UITabBarController {
        let vc = TabBarViewController()
        vc.router = router
        vc.setUpViewControllers()
        return vc
    }
    
    func createShopViewController(_ router: RouterProtocol, shop: ShopCases) -> ShopViewController {
        let vc = ShopViewController.instantiateMyViewController()
        vc.presenter = ShopPresenter(view: vc, router: router, shop: shop)
        return vc
    }
    
    func createGameViewContoller(_ router: RouterProtocol, conectionManager: PeerContectionManager, adsManager: AdsManager, stake: Int?, words: [String]?, isTraining: Bool) -> GameViewController {
        let vc = GameViewController.instantiateMyViewController()
        let presenter = GamePresenter(view: vc, router: router, conectionManager: conectionManager, adsManager: adsManager, isTraining: isTraining)
        presenter.stake = stake
        presenter.words = words
        vc.presenter = presenter
        return vc
    }
    
    func createAvatarViewController(_ router: RouterProtocol, delegate: AvatarUpdate?) -> AvatarViewController {
        let vc = AvatarViewController.instantiateMyViewController()
        vc.presenter = AvatarPresenter(view: vc, router: router, delegate: delegate)
        return vc
    }
    
    
}
