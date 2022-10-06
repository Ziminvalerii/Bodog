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
    var startButtonCenterX: NSLayoutConstraint?
    //MARK: - IBOutlet
    @IBOutlet weak var tipsCountLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var trainingLabel: UILabel! {
        didSet {
            trainingLabel.attributedText = setAtributedTitle("TRAINING")
            setLabelShadow(trainingLabel)
        }
    }
    @IBOutlet weak var trainingButton: UIView! {
        didSet {
            let gestureRec = UITapGestureRecognizer(target: self, action: #selector(trainingButtonPressed))
            trainingButton.addGestureRecognizer(gestureRec)
            trainingButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var startLabel: UILabel! {
        didSet {
            startLabel.attributedText = setAtributedTitle("JOIN THE GAME")
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
            //            nameTextView.layer.borderWidth = 9
            //            nameTextView.tex layer.borderColor = UIColor(red: 0, green: 126/255, blue: 109/255, alpha: 1).cgColor
            nameTextView.attributedText = setAtributedTitle(Defaults.userName)
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
            //            setUpAddButton(addHintView)
        }
    }
    @IBOutlet weak var addCoinView: UIButton! {
        didSet {
            //            setUpAddButton(addCoinView)
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
        startButtonCenterX = view.constraints.filter({$0.identifier == "startButtonCenter"}).first
        presenter.conectionManager.conectedDelegate = self
        if Defaults.coins == nil {
            Defaults.coins = 2000
        }
        if Defaults.tips == nil {
            Defaults.tips = 1
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startButtonCenterX?.constant -= view.bounds.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coinsCountLabel.attributedText = setAtributedTitle(Defaults.coins?.description ?? "", fontSize: 24)
        tipsCountLabel.attributedText = setAtributedTitle(Defaults.tips?.description ?? "", fontSize: 24)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.startButtonCenterX?.constant += self.view.bounds.size.width
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startViewButon.removeGlowAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    //MARK: - objc Methods
    
    @objc func trainingButtonPressed() {
        animateTraineView()
        
//        trainingButton.layer.bounds.size.width
//        let bounds = trainingButton.bounds
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       usingSpringWithDamping: 0.2,
//                       initialSpringVelocity: 10,
//                       options: .curveEaseInOut) {
//            self.trainingButton.bounds = CGRect(
//                x: bounds.origin.x - 50,
//                y: bounds.origin.y,
//                width: bounds.width + 100,
//                height: bounds.height)
//
//            self.trainingButton.center.x -= 50
//            self.trainingButton.bounds = bounds
//            self.view.layoutIfNeeded()
//        }
//        animateView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter.training(from: self)
        }
        
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
    
    func animateTraineView() {
        var animations = [CAAnimation]()
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 10, -10, +10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 1
        animation.isAdditive = true
        animations.append(animation)
//        trainingButton.layer.add(animation, forKey: "shake")
        let widthAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        widthAnimation.values = [1, 1.25, 0.75, 1.25, 1]
        widthAnimation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        widthAnimation.duration = 1
        animations.append(widthAnimation)
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 2.0
//        widthAnimation.isAdditive = true
        trainingButton.layer.add(group, forKey: nil)
    }
    
    
    func setAtributedTitle(_ str: String, fontSize:CGFloat = 17.0) -> NSAttributedString {
        //        if #available(iOS 16.0, *) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor(red: 0, green: 126/255, blue: 109/255, alpha: 1),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -2.0,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: .heavy/*, width: .expanded*/)
        ]
        let textWithStroke = NSAttributedString(
            string: str,
            attributes: attributes
        );
        
        return textWithStroke
        //        } else {
        //            let attributes: [NSAttributedString.Key: Any] = [
        //                NSAttributedString.Key.strokeColor: UIColor(red: 0, green: 126/255, blue: 109/255, alpha: 1),
        //                NSAttributedString.Key.foregroundColor: UIColor.white,
        //                NSAttributedString.Key.strokeWidth: -2.0,
        //                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .heavy)
        //            ]
        //            let textWithStroke = NSAttributedString(
        //                string: str,
        //                attributes: attributes
        //            );
        //
        //            return textWithStroke
        //        };
        //
        
    }
    
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
    
    func animateView() {
       
    }
    
    //MARK: - IBActions
    @IBAction func settingsButtonPressed(_ sender: Any) {
        presenter.goToSettingViewController(from: self)
    }
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

