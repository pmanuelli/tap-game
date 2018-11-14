
import UIKit
import RxSwift

class GameViewHighScoreBeatenAnimator {
    
    private let view: GameView
    
    init(view: GameView) {
        self.view = view
    }
    
    func animate() {
        
        animateScore()
        animateHighScoreBeatenLabel()
    }
    
    private func animateScore() {
        
        let data = [
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 0.85), duration: 0.1),
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 1.3), duration: 0.1),
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 0.9), duration: 0.1),
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 1.1), duration: 0.05),
            UIView.AnimateTransformData(transform: .identity, duration: 0.05)
        ]
        
        UIView.animate(view.scoreLabel, data: data)
    }
    
    private func animateHighScoreBeatenLabel() {
        
        let label = view.highScoreBeatenLabel!
        
        label.alpha = 0
        label.isHidden = false
        label.transform = CGAffineTransform(scale: 0.1)
        
        let otherData = [
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 1.3), duration: 0.1, delay: 0.1),
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 0.9), duration: 0.1),
            UIView.AnimateTransformData(transform: CGAffineTransform(scale: 1.1), duration: 0.05),
            UIView.AnimateTransformData(transform: .identity, duration: 0.05)
        ]
        
        UIView.animate(label, data: otherData)
        UIView.animate(withDuration: 0.2,
                       animations: { label.alpha = 1 },
                       completion: { _ in self.animateHighScoreBeatenLabelDisappear() })
    }
    
    private func animateHighScoreBeatenLabelDisappear() {
        
        let label = view.highScoreBeatenLabel!
        
        UIView.animate(withDuration: 2,
                       delay: 2,
                       animations: { label.alpha = 0 })
    }
}
