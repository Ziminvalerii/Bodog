import UIKit

class LoaderViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    private lazy var welcomeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.frame.size = CGSize(width: 300, height: 50)
//        imageView.center = view.center
//        imageView.center.y -= 32
//        imageView.image = UIImage(named: "welcome")
//        return imageView
//    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.frame.size = CGSize(width: 250, height: 50)
        progressView.center.x = view.center.x
        progressView.frame.origin.y = view.bounds.height - 50
        
        progressView.progressTintColor = .white
        
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        
        progressView.progress = 0.0
        
        progressView.transform = CGAffineTransform(scaleX: 1, y: 5)
        
        return progressView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "loaderBG")
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)

        view.addSubview(progressView)
        
//        view.addSubview(welcomeImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let randomCount = Int.random(in: 3...6)
        let piece = 1.0 / Float(randomCount)

        for i in 1...randomCount {
            self.progressView.setProgress(Float(i) * piece, animated: true)
            RunLoop.current.run(until: Date() + Double.random(in: 0.8...1.5))
        }
        
        let progressViewCenter = progressView.center
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.progressView.alpha = 0
        } completion: { _ in
            
            let builder = Builder()
            let router = Router(builder: builder)
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            delegate.window?.rootViewController = router.presentTabBar()
//            Defaults.coins = 10000
        }
    }
}
