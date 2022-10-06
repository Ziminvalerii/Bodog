//
//  WordSlotSprite.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 13.09.2022.
//

import SpriteKit

class WordSlotSprite: SKSpriteNode {
    
    //MARK: - Properties
    weak var touchDelegate: TouchDelegate?
    var shouldAcceptTouches: Bool = true {
        didSet {
            self.isUserInteractionEnabled = shouldAcceptTouches
        }
    }
    var firstPosition : CGPoint?
    var char: String? {
        didSet {
            charLabel.text = char
        }
    }
    private lazy var charLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 40
        label.fontName = "Copperplate Bold"
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0, y: -12)
        return label
    }()
    private lazy var shadow: SKSpriteNode = {
        let sprite = SKSpriteNode(imageNamed: "worldSlot")
        sprite.size = CGSize(width: 64, height: 64)
        sprite.blendMode = SKBlendMode.alpha
        sprite.colorBlendFactor = 1
        sprite.color = SKColor.black
        sprite.alpha = 0.3
        sprite.zPosition = -1
        sprite.position = CGPoint(x: 0, y: self.frame.midY - 10)
        return sprite
    }()
    //MARK: -Initializer
    convenience init() {
        self.init(imageNamed: "worldSlot")
        self.size = CGSize(width: 64, height: 64)
       
        
        charLabel.zPosition = 10
        addChild(charLabel)
        addChild(shadow)
//        self.isUserInteractionEnabled = true
        
    }
    //MARK: - Animations
    func moveTo(_ point: CGPoint, with duration: TimeInterval, complition: (() -> Void)? = nil) {
        shouldAcceptTouches = false
        if firstPosition == nil {
        firstPosition = self.position
        }
        let action = SKAction.move(to: point, duration: duration)
        self.run(action) {
            self.shouldAcceptTouches = true
            complition?()
        }
    }

}

//MARK: -Touches
extension WordSlotSprite: Touchable {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldAcceptTouches {
        if containsTouches(touches: touches) {
            let clickSound = SKAction.playSoundFileNamed("clickSound.wav", waitForCompletion: false)
            run(clickSound)
            touchDelegate?.touchesBegan(self)
        }
        }
    }
    
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { return false }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
    
}
//MARK: - Delegate
protocol TouchDelegate: AnyObject {
    func touchesBegan(_ node: WordSlotSprite)
}
