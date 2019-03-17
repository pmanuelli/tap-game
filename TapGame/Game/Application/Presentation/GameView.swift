
import UIKit
import RxSwift
import RxCocoa

struct UserTap {
    let location: CGPoint
}

class GameView: UIView {

    @IBOutlet var secondsLeftLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreBeatenLabel: UILabel!
    
    @IBOutlet var startTappingMessageView: UIView!
   
    @IBOutlet var tappableView: UIView!
    @IBOutlet var backgroundView: RippleEffectView!
    
    var userTaps: Observable<UserTap>!
    
    func hideScore() {
        scoreLabel.isHidden = true
    }
    
    func updateBackground(color: UIColor, tapPoint: CGPoint) {
        backgroundView.touchIn(point: tapPoint, newColor: color)
    }
    
    func hideHighScoreBeatenMessage() {
        highScoreBeatenLabel.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTappableView()
    }
    
    private func setupTappableView() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        
        userTaps = tapGestureRecognizer.rx
            .event
            .map({ UserTap(location: $0.location(in: self.backgroundView)) })
        
        tappableView.addGestureRecognizer(tapGestureRecognizer)
    }
}
