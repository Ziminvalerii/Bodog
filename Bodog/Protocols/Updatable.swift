//
//  Updatable.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 14.09.2022.
//

import Foundation


protocol Updatable: AnyObject {
    
    // MARK: - Methods
    
    func update(_ currentTime: TimeInterval)
}

extension Updatable {
    func update() { }
}
