//
//  CreateGamePresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit


protocol CreateGameViewProtocol : AnyObject {
    func updateStakeLabel(with stake: Int)
    
}


protocol CreateGamePresenterProtocol : AnyObject {
    var conectionManager: PeerContectionManager { get }
    
   
    
    // MARK: - Inizializator
    init(view: CreateGameViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager, adsManager: AdsManager)
    //MARK: - Methods
    func goToGameViewController(from vc: UIViewController)
    func sliderValueChanged(_ slider: UISlider)
    func setUpStakeLabel(_ slider: UISlider)
    func showAds(at vc: UIViewController)
}


class CreateGamePresenter : CreateGamePresenterProtocol {
    //MARK: -Properies
    private var indexArr: Int {
        return Int.randomVal(min: 0 , max: ConstantsValues.angramsArray.count-1)
    }
    let stakes: [Int] = [100, 250, 500, 1000, 2000, 5000, 10000, 25000, 50000, 100000]
    var currentIndexAtSlider: Int = 0 {
        didSet {
            guard let view = view else { return }
            if currentIndexAtSlider >= 0 && currentIndexAtSlider < stakes.count {
            view.updateStakeLabel(with: stakes[currentIndexAtSlider])
            }
        }
    }
    weak var view: CreateGameViewProtocol?
    var conectionManager: PeerContectionManager
    var adsManager: AdsManager
    private var router: RouterProtocol
    //MARK: -Initializer
    required init(view: CreateGameViewProtocol, router: RouterProtocol, conectionManager: PeerContectionManager,adsManager: AdsManager) {
        self.view = view
        self.router = router
        self.conectionManager = conectionManager
        self.adsManager = adsManager
    }
    //MARK: -Slider Methods
    func setUpStakeLabel(_ slider: UISlider) {
        currentIndexAtSlider = Int(slider.value)-1
        if currentIndexAtSlider >= 0 && currentIndexAtSlider < stakes.count {
            guard let view = view else { return }
        view.updateStakeLabel(with: stakes[currentIndexAtSlider])
        }
    }
    func sliderValueChanged(_ slider: UISlider) {
        let step: Float = 1
        currentIndexAtSlider = Int((slider.value - slider.minimumValue) / step)
    }
    
    //MARK: -ADS
    func showAds(at vc: UIViewController) {
        adsManager.showRewardedAds(at: vc) { reward in
            if reward != nil {
                self.goToGameViewController(from: vc)
            }
        }
    }
    //MARK: -Navigation
    func goToGameViewController(from vc: UIViewController) {
        var indexAr: Int = indexArr
        let word = ConstantsValues.angramsArray[indexAr]
        router.goToGameViewController(from: vc, conectionManager: conectionManager, adsManager: adsManager, stake: stakes[currentIndexAtSlider], words: word, isTraining: false)
    }
    
}
