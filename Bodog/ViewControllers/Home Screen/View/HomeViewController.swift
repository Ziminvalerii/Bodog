//
//  HomeViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit
import GoogleMobileAds
import MultipeerConnectivity

class HomeViewController: BaseViewController<HomePresenterProtocol>, HomeViewProtocol, PeerConectedProtocol {
   
    
    //MARK: - Properties
    var startGameButtonPressed = false
    //MARK: - IBOutlet
    @IBOutlet weak var tipsCountLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var trainingLabel: UILabel! {
        didSet {
            setLabelShadow(trainingLabel)
        }
    }
    @IBOutlet weak var trainingButton: UIView! {
        didSet {
            let gestureRec = UITapGestureRecognizer(target: self, action: #selector(trainingButtonPressed))
            trainingButton.addGestureRecognizer(gestureRec)
        }
    }
    @IBOutlet weak var startLabel: UILabel! {
        didSet {
            setLabelShadow(startLabel)
        }
    }
    @IBOutlet weak var coinsCountLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var nameTextView: UITextView! {
        didSet {
            nameTextView.text = Defaults.userName
            nameTextView.textContainer.maximumNumberOfLines = 1
            nameTextView.delegate = self
        }
    }
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.image = UIImage(named: "person\(Defaults.imageIndex)")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped))
            avatarImage.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var addHintView: UIButton! {
        didSet {
            setUpAddButton(addHintView)
        }
    }
    @IBOutlet weak var addCoinView: UIButton! {
        didSet {
            setUpAddButton(addCoinView)
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var startViewButon: UIView! {
        didSet {
            let gestureRec = UITapGestureRecognizer(target: self, action: #selector(startViewButtonTapped))
            startViewButon.addGestureRecognizer(gestureRec)
        }
    }
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        presenter.conectionManager.conectedDelegate = self
        if Defaults.coins == nil {
            Defaults.coins = 2000
        }
        if Defaults.tips == nil {
            Defaults.tips = 1
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coinsCountLabel.text = Defaults.coins?.description
        tipsCountLabel.text = Defaults.tips?.description
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startViewButon.removeGlowAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    //MARK: - objc Methods
    
    @objc func trainingButtonPressed() {
        presenter.training(from: self)
        
    }
    
    @objc func startViewButtonTapped() {
        startGameButtonPressed = !startGameButtonPressed
        if startGameButtonPressed {
            startViewButon.doGlowAnimation(withColor: UIColor.white, withEffect: .big)
            presenter.conectionManager.startAdvertisingPeer()
        } else {
            startViewButon.removeGlowAnimation()
            presenter.conectionManager.stopAvertisingPeer()
        }
    }
    
    @objc func avatarImageTapped() {
        print("Taped")
        presenter.goToAvatarsViewController(form: self)
    }
    
    //MARK: - Functions
    
    func setUpAddButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func setLabelShadow(_ label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    //MARK: - Conformance to HomeViewProtocol
    
    func updateImage(with image: UIImage) {
        avatarImage.image = image
    }
    
    //MARK: - Connected to peer
    func connected() {
        presenter.goToGameViewController(from: self)
//        presenter.showAds(at: self)
    }
    
    //MARK: - IBActions
    @IBAction func addCoinButtonPressed(_ sender: Any) {
        presenter.goToShopVC(from: self, shop: .coin)
    }
    @IBAction func addHintButtonPressed(_ sender: Any) {
        presenter.goToShopVC(from: self, shop: .tip)
    }
    @IBAction func instructionButtonPressed(_ sender: Any) {
        presenter.goToInstruction(from: self)
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

//MARK: - TextView Delegate

extension HomeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        Defaults.userName = textView.text
    }
}

