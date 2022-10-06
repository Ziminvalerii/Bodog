//
//  ShopPresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import Foundation
import UIKit


enum ShopCases {
    case coin
    case tip
}

protocol ShopViewProtocol : AnyObject, MessageManager {
    func reloadData()
    func updateLabels()
}


protocol ShopPresenterProtocol : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init(view: ShopViewProtocol, router: RouterProtocol, shop: ShopCases)
    func goBack(form vc: UIViewController)
}


class ShopPresenter : NSObject, ShopPresenterProtocol {
    var iapManager = IAPManager()
    var products: [ProductSub]?
    weak var view: ShopViewProtocol?
    var shopCase: ShopCases
    var productInfo:[Product]?
    private var router: RouterProtocol
    
    required init(view: ShopViewProtocol, router: RouterProtocol, shop: ShopCases) {
        self.view = view
        self.router = router
        self.shopCase = shop
        super.init()
        self.setProductArray()
    }
    
    func setProductArray() {
        switch shopCase {
        case .coin:
            getProducts()
//            productInfo = [Product(imageName: "smallCoins", count: 100),
//                           Product(imageName: "mediumCoins", count: 500),
//                           Product(imageName: "bigCoins", count: 2000),
//                           Product(imageName: "coinBag", count: 10000),
//                           Product(imageName: "mediumCoinBag", count: 25000),
//                           Product(imageName: "bigCoinBag", count: 100000)]
        case .tip:
            productInfo = [Product(imageName: "tipImage", count: 1, price: 100),
                           Product(imageName: "smallTipGroup", count: 5, price: 400),
                           Product(imageName: "bigTipGroup", count: 10, price: 750),
                           Product(imageName: "tipBag", count: 20, price: 1500),
                           Product(imageName: "MediumTipBag", count: 50, price: 4000),
                           Product(imageName: "bigTipBag", count: 75, price: 6500)]
        }
        view?.reloadData()
    }
    
    func getProducts() {
        iapManager.requestProducts { products in
            self.products = products
            self.view?.reloadData()
        }
    }
    
    func goBack(form vc: UIViewController) {
        router.dismissCurrentVC(vc)
    }
    
    @objc func buyButtonTapped(_ sender: UIButton) {
        let index =  sender.tag
        guard Defaults.coins != nil, Defaults.tips != nil else { return }
        if shopCase == .coin {
            guard let product = products?[index] else { return }
            iapManager.buyProduct(product.product) { success, productId in
                if  success {
                    Defaults.coins! += product.count
                    self.view?.updateLabels()
                    
                } else {
                    DispatchQueue.main.async {
                        self.view?.showErrorMessage(title: "Error", message: "Something went wrong", actionText: nil, isForever: false, action: nil)
                    }
                }
            }
        } else {
            guard let productInfo = productInfo?[index] else { return }
           
            if productInfo.price > Defaults.coins! {
                view?.showErrorMessage(title: "Error", message: "You didnt have enought money", actionText: nil, isForever: false, action: nil)
                return
            }
            view?.showSuccessMessage(title: "Success", message: "All set", actionText: nil, isForever: false, action: nil)
            Defaults.coins! -= productInfo.price
            Defaults.tips! += productInfo.count
            view?.updateLabels()

        }
        
        
    }
    
}
//MARK: - Conformance to CollectionView Delegate

extension ShopPresenter: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopCase == .coin ? products?.count ?? 0 : productInfo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buy_cell", for: indexPath) as! BuyCollectionViewCell
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = false
        if shopCase == .coin {
            guard let products = products else { return UICollectionViewCell() }
            cell.configure(model: products[indexPath.row])
            
        } else {
            guard let productInfo = productInfo else { return UICollectionViewCell() }
        let data = productInfo[indexPath.row]
            cell.configure(model: data, shop: shopCase)
    }
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: #selector(buyButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width/2 - 10*2
//        collectionViewLayout.
        return CGSize(width: width, height: width)
    }
}

