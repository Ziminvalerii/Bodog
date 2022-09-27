//
//  InstructionViewController.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 26.09.2022.
//

import UIKit
import Lottie

class InstructionViewController: BaseViewController<InstructionPresenterProtocol>, InstructionProtocol {

    @IBOutlet weak var thirdAnimationView: AnimationView!
    @IBOutlet weak var secondAnimationView: AnimationView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationView: AnimationView! {
        didSet {
//            animationView.
            startAnimation(animationSpeed: 1, animationView)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var index:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let frame = view.frame
        widthConstraint.constant =  frame.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
        secondAnimationView.stop()
        thirdAnimationView.stop()
    }
    
    private func scrollToIndex(index: Int) {
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * widthConstraint.constant,
                                              y: 0,
                                              width: view.frame.width,
                                              height: view.frame.height), animated: true)
    }
    
    private func startAnimation ( animationSpeed : CGFloat, _ animation : AnimationView) {
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.animationSpeed = animationSpeed
        animation.play()
    }
    

    @IBAction func prevButtonPressed(_ sender: Any) {
        guard index > 0 else { return }
        index -= 1
        scrollToIndex(index: index-1)
        switch index {
        case 1:
            secondAnimationView.stop()
            startAnimation(animationSpeed: 1, animationView)
        case 2:
            thirdAnimationView.stop()
            startAnimation(animationSpeed: 1, secondAnimationView)
        default:
            break;
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        if index < 3 {
            scrollToIndex(index: index)
            switch index {
            case 1:
                animationView.stop()
                startAnimation(animationSpeed: 1, secondAnimationView)
            case 2:
                secondAnimationView.stop()
                startAnimation(animationSpeed: 1, thirdAnimationView)
            default:
                break;
            }
            index += 1
        } else {
            presenter.dismissVC(from: self)
        }
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        presenter.dismissVC(from: self)
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
