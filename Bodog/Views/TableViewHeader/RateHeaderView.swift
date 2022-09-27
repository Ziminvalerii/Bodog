//
//  RateHeaderView.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 19.09.2022.
//

import UIKit

class RateHeaderView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordsCountLabel: UILabel!
    @IBOutlet weak var headerView: UIView! {
        didSet {
        }
    }
    //MARK: -Propeties
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
//        view.layer.cornerRadius = 25
        //        view.layer.masksToBounds = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: RateHeaderView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    func configure(with wordsCount:Int, score:Int) {
        wordsCountLabel.text = "Words: \(wordsCount.description)"
        scoreLabel.text = "SCORE: \(score.description)"
    }
}
