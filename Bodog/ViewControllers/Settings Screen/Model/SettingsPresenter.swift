//
//  SettingsPresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 05.10.2022.
//

import UIKit



protocol SettingsViewProtocol : AnyObject {
}


protocol SettingsPresenterProtocol : AnyObject {
    init(view: SettingsViewProtocol, router: RouterProtocol)
    func goToShopVc(from vc:UIViewController)
    func dissmissFrom(_ vc: UIViewController)
}


class SettingsPresenter : SettingsPresenterProtocol {
    
    weak var view: SettingsViewProtocol?
    private var router: RouterProtocol
    
    required init(view: SettingsViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    //MARK: - Methods
    
    func dissmissFrom(_ vc: UIViewController) {
        router.dismissCurrentVC(vc)
    }
    func goToShopVc(from vc:UIViewController) {
        router.presentShopVC(from: vc, shop: .coin)
    }
    
    
}
