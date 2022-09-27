//
//  ShopViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import UIKit

class ShopViewController: BaseViewController<ShopPresenterProtocol>, ShopViewProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var tipCountLabel: UILabel! {
        didSet {
            tipCountLabel.text = Defaults.tips?.description
        }
    }
    @IBOutlet weak var coinLabel: UILabel! {
        didSet {
            coinLabel.text = Defaults.coins?.description
        }
    }
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = presenter
            collectionView.dataSource = presenter
        }
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBActions
    @IBAction func crossButtonTapped(_ sender: Any) {
        presenter.goBack(form: self)
    }
    
    //MARK: - Conformance to ShopViewProtocol
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateLabels() {
        tipCountLabel.text = Defaults.tips?.description
        coinLabel.text = Defaults.coins?.description
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
