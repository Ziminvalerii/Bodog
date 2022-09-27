//
//  SpiteNode.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 21.09.2022.
//

import SpriteKit


extension SKSpriteNode {
    func addGlow(radius: Float = 30) {
            let effectNode = SKEffectNode()
            effectNode.shouldRasterize = true
            addChild(effectNode)
            let effect = SKSpriteNode(texture: texture)
            effect.color = self.color
            effect.colorBlendFactor = 1
            effectNode.addChild(effect)
            effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
        }
}
