//
//  TabBarViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    var router: RouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTabBar()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    func setUpViewControllers() {
        setViewControllers(router?.setUpTabBarVC(), animated: true)
    }
    
    func configureTabBar() {
        if #available(iOS 15, *) {
            let appearence = UITabBarAppearance()
            appearence.configureWithOpaqueBackground()
            appearence.backgroundColor = .clear
            setTabBarItemColors(appearence.stackedLayoutAppearance)
            setTabBarItemColors(appearence.compactInlineLayoutAppearance)
            setTabBarItemColors(appearence.inlineLayoutAppearance)
            self.tabBar.standardAppearance = appearence
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        } else {
            self.tabBar.barTintColor = .clear
            self.tabBar.unselectedItemTintColor = .black
            self.tabBar.tintColor = .white
        }
    }

    
    private func setTabBarItemColors( _ itemAppearence: UITabBarItemAppearance) {
        itemAppearence.selected.titleTextAttributes = [.foregroundColor : UIColor.white]
        itemAppearence.selected.iconColor = UIColor.white
        itemAppearence.normal.titleTextAttributes = [.foregroundColor : UIColor(red: 0, green: 126/255, blue: 109/255, alpha: 1)]
        itemAppearence.normal.iconColor = UIColor(red: 0, green: 126/255, blue: 109/255, alpha: 1)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
