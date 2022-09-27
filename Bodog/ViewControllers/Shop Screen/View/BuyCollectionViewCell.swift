//
//  BuyCollectionViewCell.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import UIKit

class BuyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    //MARK: -View Configuration
    func configure( model: Product, shop: ShopCases) {
        let str = shop == .coin ? "coins" : "tips"
        cellImage.image = UIImage(named: model.imageName) ?? UIImage(named: "smallCoins")!
        countLabel.text = "\(model.count.description) \(str)"
        buyButton.setTitle("\(model.price.description) coins", for: .normal)
    }
    
    func configure(model:ProductSub) {
        countLabel.text = model.title
        buyButton.setTitle(model.price, for: .normal)
        cellImage.image = setUPImage(model.subsctiption)
    }
    
    //MARK: -Private Methods
    private func setUPImage(_ id:Subscription) -> UIImage {
        switch id {
        case .hundredCoins:
            return UIImage(named: "smallCoins")!
        case .fiveHundredCoins:
            return UIImage(named: "mediumCoins")!
        case .twoThousandCoins:
            return UIImage(named: "bigCoins")!
        case .tenThousandCoins:
            return UIImage(named: "coinBag")!
        case .twentyFiveThousandCoins:
            return UIImage(named: "mediumCoinBag")!
        case .hundredThousandCoins:
            return UIImage(named: "bigCoinBag")!
        }
    }
   
}


