//
//  RightAlignedIconButton.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 05.10.2022.
//

import UIKit


@IBDesignable
class RightAlignedIconButton: UIButton {

    override func layoutSubviews() {
            super.layoutSubviews()
            semanticContentAttribute = .forceRightToLeft
            contentHorizontalAlignment = .right
            let availableSpace = bounds.inset(by: contentEdgeInsets)
            let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
        }

}
