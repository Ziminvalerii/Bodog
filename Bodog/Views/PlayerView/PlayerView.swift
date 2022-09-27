//
//  PlayerView.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 19.09.2022.
//

import UIKit

class PlayerView: UIView {

    //MARK: - IBOutlets
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
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

        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: PlayerView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(plyerName: String, imageName:String) {
        playerImageView.image = UIImage(named: imageName)
        playerLabel.text = plyerName
    }

}
