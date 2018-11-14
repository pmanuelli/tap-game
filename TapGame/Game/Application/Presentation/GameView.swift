
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
    
    private var userTapsSubject: PublishSubject<UserTap>!
    
    func setSecondsLeft(_ secondsLeft: Int) {
        secondsLeftLabel.text = "\(secondsLeft)\""
    }
    
    func hideScore() {
        scoreLabel.isHidden = true
    }
    
    func showScore(_ score: Int) {
        scoreLabel.isHidden = false
        scoreLabel.text = "\(score)"
    }
    
    func hideStartTappingMessage() {
        startTappingMessageView.isHidden = true
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
        setupTapSubject()
    }
    
    private func setupTappableView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappableViewTapped))
        tappableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTapSubject() {
        userTapsSubject = PublishSubject<UserTap>()
        userTaps = userTapsSubject.asObservable()
    }
    
    @objc
    private func tappableViewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: backgroundView)
        userTapsSubject.onNext(UserTap(location: location))
    }
}
