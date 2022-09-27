//
//  BaseViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit


class BaseViewController<T> : UIViewController, ViewAnimationTransition {
    var presenter: T!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func instantiateMyViewController() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return vc
    }
    
    //MARK: - View Transition
    
  
    
    
}

