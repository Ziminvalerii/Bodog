//
//  SettingsViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 05.10.2022.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsPresenterProtocol>, SettingsViewProtocol {

    @IBOutlet weak var musicSwitch: UISwitch! {
        didSet {
            musicSwitch.isOn = !isSilent
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToShopButtonPressed(_ sender: Any) {
        presenter.goToShopVc(from: self)
    }
    @IBAction func crossButtonPressed(_ sender: Any) {
        presenter.dissmissFrom(self)
    }
    
    @IBAction func musicSwitchValueChanged(_ sender: UISwitch) {
        isSilent = !sender.isOn
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
