//
//  AvatarViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit

class AvatarViewController: BaseViewController<AvatarPresenterProtocol>, AvatarViewProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
        }
    }
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
    @IBAction func doneButtonPressed(_ sender: Any) {
        presenter.goBack(form: self)
    }
    
    //MARK: - Conformance to AvatarViewProtocol
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
