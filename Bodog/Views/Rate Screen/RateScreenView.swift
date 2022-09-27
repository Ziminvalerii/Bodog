//
//  RateView.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 22.09.2022.
//

import UIKit

class RateScreenView: UIView {
    //MARK: -Propeties
    var firstPlayerTotalScore: Int?
    var secondPlayerTotalScore:Int?
    var firstPlayerItems: [RateModel] = [] {
        didSet {
            firstPlayerTableView.items = firstPlayerItems
            firstPlayerTableView.reloadData()
            let count = firstPlayerItems.count
            var totalScore = 0
            firstPlayerItems.forEach({totalScore += $0.score})
            firstPlayerView.configure(with: count, score: totalScore)
            self.firstPlayerTotalScore = totalScore
        }
    }
    
    var secondPlayerItems: [RateModel] = [] {
        didSet {
            secondPlayerTableView.items = secondPlayerItems
            secondPlayerTableView.reloadData()
            let count = secondPlayerItems.count
            var totalScore = 0
            secondPlayerItems.forEach({totalScore += $0.score})
            secondPlayerView.configure(with: count, score: totalScore)
            self.secondPlayerTotalScore = totalScore
        }
    }
    var contentView: UIView?
    //MARK: - IBOutlets
    @IBOutlet weak var secondPlayerTableView: ScoreTableView!
    @IBOutlet weak var firstPlayerTableView: ScoreTableView!
    @IBOutlet weak var firstPlayerView: RateHeaderView!
    @IBOutlet weak var secondPlayerView: RateHeaderView!
   
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
        firstPlayerTableView.register(UINib(nibName: String(describing: ScoreTableViewCell.self), bundle: nil), forCellReuseIdentifier: "ScoreTableViewCell")
        firstPlayerTableView.reloadData()
        secondPlayerTableView.register(UINib(nibName: String(describing: ScoreTableViewCell.self), bundle: nil), forCellReuseIdentifier: "ScoreTableViewCell")
        secondPlayerTableView.reloadData()
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: RateScreenView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: UI Methods
    func setHiddenSecondPlayer() {
        secondPlayerTableView.isHidden = true
        secondPlayerView.isHidden = true
    }
}
