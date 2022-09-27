//
//  InstructionPresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 26.09.2022.
//

import UIKit

protocol InstructionProtocol : AnyObject {
    
}

protocol InstructionPresenterProtocol : AnyObject {
   
    init(view: InstructionProtocol, router: RouterProtocol)
    func dismissVC(from vc: UIViewController)
}

class InstructionPresenter: InstructionPresenterProtocol {
    
    weak var view : InstructionProtocol?
    private var router: RouterProtocol
    
    required init(view: InstructionProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismissVC(from vc: UIViewController) {
        router.dismissCurrentVC(vc)
    }
}
