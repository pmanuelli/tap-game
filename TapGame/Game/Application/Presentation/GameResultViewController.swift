
import UIKit

class GameResultViewController: UIViewController {

    lazy var mainView = GameResultView.loadNib()
    
    private let score: Int
    
    init(score: Int) {
        
        self.score = score
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.showScore(score)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.scoreLabel.transform = CGAffineTransform(translationX: 0, y: -100)
        }, completion: { _ in
            
            self.mainView.retryButton.alpha = 0
            self.mainView.retryButton.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.mainView.retryButton.alpha = 1
            })
        })
    }
}
