//
//  Product.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 21.09.2022.
//

import StoreKit

public struct ProductSub: Hashable {
    let subsctiption: Subscription
    var count: Int
    let title: String
    var price: String?
    let locale: Locale
    let product: SKProduct
    
    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(_ product: SKProduct) {
        self.product = product
        self.subsctiption = Subscription.allCases.first(where: {$0.rawValue == product.productIdentifier}) ?? .hundredCoins
        self.title = product.localizedTitle
        self.locale = product.priceLocale
        
        switch subsctiption {
        case .hundredCoins:
            count = 100
        case .fiveHundredCoins:
            count = 500
        case .twoThousandCoins:
            count = 2000
        case .tenThousandCoins:
            count = 10000
        case .twentyFiveThousandCoins:
            count = 25000
        case .hundredThousandCoins:
            count = 100000
        }
        self.price = formatter.string(from: product.price)
    }
    
    
}
