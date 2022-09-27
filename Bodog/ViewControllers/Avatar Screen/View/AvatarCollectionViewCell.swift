//
//  AvatarCollectionViewCell.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    
    func configureCell(with image: UIImage) {
        self.imageCell.image = image
    }
    
    
}
