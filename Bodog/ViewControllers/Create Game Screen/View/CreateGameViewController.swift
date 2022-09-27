//
//  CreateGameViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit

class CreateGameViewController: BaseViewController<CreateGamePresenterProtocol>, CreateGameViewProtocol, PeerConectedProtocol {
   
    
    //MARK: - IBoulets
    @IBOutlet weak var startLabel: UILabel! {
        didSet {
            startLabel.layer.shadowColor = UIColor.black.cgColor
            startLabel.layer.shadowRadius = 1.0
            startLabel.layer.shadowOpacity = 1.0
            startLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }
    @IBOutlet weak var tipCountLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var cointCoinLabel: UILabel!
    @IBOutlet weak var stakeLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var startViewButton: UIView! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statViewButtonTapped))
            startViewButton.addGestureRecognizer(gestureRecognizer)
            
        }
    }
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.setMaximumTrackImage(UIImage(named: "sliderImage")!, for: .normal)
            slider.setMinimumTrackImage(UIImage(named: "sliderImage")!, for: .normal)
            slider.setThumbImage(UIImage(named: "tumbImage")!, for: .normal)
        }
    }
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setUpStakeLabel(slider)
        presenter.conectionManager.conectedDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        tipCountLabel.text = Defaults.tips?.description
        cointCoinLabel.text = Defaults.coins?.description
    }
    
    //MARK: - @objc Methods
    
    @objc func statViewButtonTapped() {
        presenter.conectionManager.presentMCBrowser(from: self)
    }
    
    //MARK: - CreateGameViewProtocol
    
    func updateStakeLabel(with stake: Int) {
        stakeLabel.text = "Your stake: \(stake)"
    }

    @IBAction func sliderValeChanged(_ sender: UISlider) {
        presenter.sliderValueChanged(sender)
    }
    
    
    func connected() {
        presenter.goToGameViewController(from: self)
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
