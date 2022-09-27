//
//  File.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit
import GoogleMobileAds


protocol HomeViewProtocol : AnyObject {
    func updateImage(with image: UIImage)
}


protocol HomePresenterProtocol : AnyObject {
//    var adsManager: AdsManager { get }
    var conectionManager: PeerContectionManager { get }
    var rewardedInterstitial : GADRewardedInterstitialAd? {get}
    init(view: HomeViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager,adsManager: AdsManager)
    func goToAvatarsViewController(form vc: UIViewController)
    func goToGameViewController(from vc: UIViewController)
    func goToShopVC(from vc:UIViewController, shop: ShopCases)
    func showAds(at vc: UIViewController)
    func training(from vc: UIViewController)
    func goToInstruction(from vc:UIViewController)
}


class HomePresenter : HomePresenterProtocol, AvatarUpdate {
    
//    var adsManager: AdsManager = AdsManager()
    
    //MARK: - Propeties
    weak var view: HomeViewProtocol?
    var rewardedInterstitial : GADRewardedInterstitialAd?
    var conectionManager: PeerContectionManager
    private var router: RouterProtocol
    var adsManager: AdsManager
    
    //MARK: - Inizializator
    required init(view: HomeViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager, adsManager: AdsManager) {
        self.view = view
        self.router = router
        self.conectionManager = conectionManager
        self.adsManager = adsManager
    }
    
    //MARK: - ADS
   
    func training(from vc: UIViewController) {
        let index = Int.randomVal(min: 0, max: ConstantsValues.angramsArray.count-1)
        router.goToGameViewController(from: vc, conectionManager: conectionManager, adsManager: adsManager, stake: nil, words: ConstantsValues.angramsArray[index], isTraining: true)
    }
    
        func showAds(at vc: UIViewController) {
            adsManager.showRewardedAds(at: vc) { reward in
                if reward != nil {
                    self.goToGameViewController(from: vc)
                }
            }
        }
    
    //MARK: - Navigation
    func goToGameViewController(from vc: UIViewController) {
        router.goToGameViewController(from: vc, conectionManager: conectionManager, adsManager: adsManager, stake: nil, words: nil, isTraining: false/*, adsManager: adsManager, score: nil*/)
    }
    
    func goToAvatarsViewController(form vc: UIViewController) {
        router.presentAvatarViewController(from: vc, delegate: self)
    }
    
    func goToShopVC(from vc:UIViewController, shop: ShopCases) {
        router.presentShopVC(from: vc, shop: shop)
    }
    
    func goToInstruction(from vc:UIViewController) {
        router.presentInstruction(from: vc)
    }
    
    //MARK: - Conformance to AvatarUpdate
    func updateImage(with image: UIImage) {
        view?.updateImage(with: image)
    }
    
    
}
