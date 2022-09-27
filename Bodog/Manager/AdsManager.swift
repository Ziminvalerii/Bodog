//
//  AdsManager.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 20.09.2022.
//

import UIKit
import GoogleMobileAds

typealias RewardAdsComplitionHandler = (_ reward: GADAdReward?) -> Void

class AdsManager: NSObject {
    //MARK: - Properties
    var rewardedInterstitial : GADRewardedInterstitialAd?
    var interstitial: GADInterstitialAd?
    private var rewardAdsComplitionHandler: RewardAdsComplitionHandler?
    var reward : GADAdReward?
    //MARK: -Initializer
    override init() {
        super.init()
        prepareRewardInterstitial()
        prepareInterstitital()
    }
    
    //MARK: - Rewarded ADS
    func prepareRewardInterstitial(complition: (() -> Void)? = nil) {
        
        GADRewardedInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            self.rewardedInterstitial = ad
//            self.rewardedInterstitial.pa
            self.rewardedInterstitial?.fullScreenContentDelegate = self
            complition?()
        }
    }
    
    func showImidiatellyRewardedAds(at vc: UIViewController, complition:  @escaping RewardAdsComplitionHandler) {
        prepareRewardInterstitial {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.rewardedInterstitial != nil {
                    self.rewardedInterstitial!.present(fromRootViewController: vc) {
                        self.reward = self.rewardedInterstitial?.adReward
                        self.rewardAdsComplitionHandler?(self.reward)
                    }
                    self.rewardAdsComplitionHandler = complition
                } else {
                    self.rewardAdsComplitionHandler = complition
                }
            }
        }
    }
    
    func showRewardedAds(at vc: UIViewController, complition : @escaping RewardAdsComplitionHandler) {
        if rewardedInterstitial != nil {
            rewardedInterstitial?.present(fromRootViewController: vc) {
                self.reward = self.rewardedInterstitial?.adReward
                self.rewardAdsComplitionHandler?(self.reward)
            }
            self.rewardAdsComplitionHandler = complition
        } else {
            self.rewardAdsComplitionHandler = complition
        }
    }
        
    //MARK: - Interstitital
    func prepareInterstitital() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-5944077600830875/3259218745",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        }
        )
    }
    
    func showInterstitial() {
        if self.interstitial != nil {
            if let vc = UIApplication.getTopViewController() {
                self.interstitial!.present(fromRootViewController: vc)
                prepareInterstitital()
            }
        }
    }
    
}
//MARK: Conformance To GADFullScreenContentDelegate
extension AdsManager: GADFullScreenContentDelegate {
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ad will present full screen")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print ("ad did dissmissed ")
//        player?.play()
        rewardAdsComplitionHandler?(reward)
        reward = nil
        prepareRewardInterstitial()
    }
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print ("ad will dissmissed ")
    }
}
