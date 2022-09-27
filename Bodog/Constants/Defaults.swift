//
//  Defaults.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit


struct Defaults {
    
    enum Key {
        static let imageIndex = "image_index"
        static let userName = "user_name"
        static let coinsCount = "coins_count"
        static let tipCount = "tips_count"
        static let dontshowAdsView = "showing_ads_info_view"
    }
    
    static var dontShowAdsInfoView: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.dontshowAdsView)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.dontshowAdsView)
        }
    }
    
    static var coins: Int? {
        get {
            UserDefaults.standard.value(forKey: Key.coinsCount) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.coinsCount)
        }
    }
    
    static var tips: Int? {
        get {
            UserDefaults.standard.value(forKey: Key.tipCount) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.tipCount)
        }
    }
    
    static var imageIndex: Int {
        get  {
            UserDefaults.standard.integer(forKey: Key.imageIndex)
        }
        set {
            if newValue >= 0 && newValue < Constants.personsCount {
                UserDefaults.standard.set(newValue, forKey: Key.imageIndex)
            } else {
                UserDefaults.standard.set(0, forKey: Key.imageIndex)
            }
        }
    }

    static var userName:String {
        get  {
            (UserDefaults.standard.value(forKey: Key.userName) as? String) ?? UIDevice.current.name
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.userName)
        }
    }
}


struct Constants {
    static let personsCount: Int = 8
}
