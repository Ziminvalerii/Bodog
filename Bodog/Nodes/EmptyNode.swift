//
//  EmptyNode.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 13.09.2022.
//

import SpriteKit

class EmptyNode: SKSpriteNode {

    var isBusy:Bool = false
    
    var busyNode:WordSlotSprite?
    
    convenience init() {
        self.init(imageNamed: "charSlot")
        self.size = CGSize(width: 64, height: 64)
        self.zPosition = 5
    }
}
