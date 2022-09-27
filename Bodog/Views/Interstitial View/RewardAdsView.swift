//
//  InterstitialView.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 25.09.2022.
//

import UIKit
//MARK: - Delegate
protocol InterstitialViewDelegate: AnyObject{
    func crossButtonTapped()
    func gotItButtonTapped()
}

class RewardAdsView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    //MARK: -Propeties
    weak var delegate: InterstitialViewDelegate?
    var contentView: UIView?
    //MARK: -Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: RewardAdsView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: -IBAction
    @IBAction func gotItButtonTapped(_ sender: Any) {
        delegate?.gotItButtonTapped()
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        delegate?.crossButtonTapped()
    }
}
