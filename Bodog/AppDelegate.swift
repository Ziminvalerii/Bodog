//
//  AppDelegate.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 13.09.2022.
//

import UIKit
import GoogleMobileAds
import Analytics
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        Analytics(dateString: "2023-09-04", appID: "6443583703", window: window) { [weak self] in
            self?.openGame()
        }.start()
        
        return true
    }
    

    func openGame() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "d5077cea83a217a577c2898bea4a490f" ]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = LoaderViewController()
        playBackgroundMusic()
    }

}
