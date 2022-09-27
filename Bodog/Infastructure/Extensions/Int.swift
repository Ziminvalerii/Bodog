//
//  Int.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 23.09.2022.
//

import Foundation


extension Int {
    static func randomVal(min:Int, max: Int) -> Int {
        Int.random(in: min...max)
    }
}
