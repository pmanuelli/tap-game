
import UIKit
import RxSwift

class GameViewTimeEndedAnimator {

    private let view: GameView
    
    init(view: GameView) {
        self.view = view
    }
    
    func animate() -> Completable {
        
        let duration: Double = 2
        let backgroundView = view.backgroundView!
        let scoreLabel = view.scoreLabel!
        
        let completableSubject = PublishSubject<Void>()
        
        UIView.animate(withDuration: duration,
                       animations: { backgroundView.backgroundColor = .white })
        
        UIView.transition(with: scoreLabel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { scoreLabel.textColor = .darkGray },
                          completion: { _ in self.sendCompleted(from: completableSubject) })
        
        return completableSubject.ignoreElements()
    }
    
    private func sendCompleted(from subject: PublishSubject<Void>) {
        subject.onNext(Void())
        subject.onCompleted()
    }
}
