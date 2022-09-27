//
//  GameSceneProtocol.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 14.09.2022.
//

import SpriteKit


protocol GameSceneProtocol {
    var scene: SKScene? { get }
    
    var updatables: [Updatable] { get set }
    var touchables: [Touchable] { get set }
    
    init?(with scene: SKScene)
}
