
import UIKit

class GameResultView: UIView {

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    
    func showScore(_ score: Int) {
        scoreLabel.text = "\(score)"
    }
    
}
