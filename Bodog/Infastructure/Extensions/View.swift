//
//  View.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import UIKit


extension UIView {
    
    func setUpRadialGradient() {
        let gradLayer = CAGradientLayer()
        gradLayer.type = .radial
        gradLayer.colors = [ UIColor.red.cgColor,
                             UIColor.white.cgColor]
        gradLayer.locations = [ 0, 1 ]
        gradLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer)
    }
    
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }

    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = .zero
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
    
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = Int.zero
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()+0.3
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.isRemovedOnCompletion = true
        glowAnimation.repeatCount  = .infinity
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
    
    func removeGlowAnimation() {
        layer.removeAnimation(forKey: "shadowGlowingAnimation")
    }
    
}


