
import UIKit
import RxSwift
import RxCocoa

extension Observable where Element == Int {
    
    static func countdownTimer(from: Int, to: Int) -> Observable<Int> {
        return Observable<Int>
            .timer(0, period: 1, scheduler: MainScheduler.instance)
            .take(from - to + 1)
            .map { from - $0 }
    }
}

class GameViewController: UIViewController {

    private lazy var mainView = GameView.loadNib()
    private let viewModel: GameViewModel
    
    private let colorGenerator = DefaultColorGenerator()
    
    private lazy var timeEndedAnimator = GameViewTimeEndedAnimator(view: mainView)
    private lazy var highScoreBeatenAnimator = GameViewHighScoreBeatenAnimator(view: mainView)
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
        
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

        hideScore()
        hideHighScoreBeatenMessage()
        
        observeUserTaps()
        
        bindSecondsLeft()
        bindScore()
        bindScoreHidden()
        bindStartTappingMessageHidden()
        
        observeHighScoreBeaten()
        observeTimeEnded()
    }
    
    private func observeUserTaps() {
        
        mainView.userTaps
            .take(1)
            .subscribe(onNext: { _ in self.firstUserTapReceived() })
            .disposed(by: disposeBag)
        
        mainView.userTaps
            .takeUntil(viewModel.timeEnded)
            .subscribe(onNext: { tap in self.userTapReceived(tap) })
            .disposed(by: disposeBag)
    }
    
    private func firstUserTapReceived() {
        viewModel.firstUserTapReceived()
    }
    
    private func userTapReceived(_ tap: UserTap) {
        viewModel.userTapReceived()
        
        updateBackgroundColor(tap: tap)
    }
    
    private func bindSecondsLeft() {
    
        viewModel.secondsLeft
            .map({ "\($0)\"" })
            .bind(to: mainView.secondsLeftLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func bindScore() {
        
        viewModel.score
            .map({ "\($0)"})
            .bind(to: mainView.scoreLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindScoreHidden() {
        
        viewModel.scoreHidden
            .drive(mainView.scoreLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindStartTappingMessageHidden() {
        
        viewModel.startTappingMessageHidden
            .drive(mainView.startTappingMessageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func observeHighScoreBeaten() {
        
        viewModel.highScoreBeaten
            .subscribe(onCompleted: { self.onHighScoreBeaten() })
            .disposed(by: disposeBag)
    }
    
    private func observeTimeEnded() {
        
        viewModel.timeEnded
            .delay(RxTimeInterval(1), scheduler: MainScheduler.instance)
            .subscribe(onCompleted: { self.onTimeEnded() })
            .disposed(by: disposeBag)
    }
    
    private func onTimeEnded() {
        
        timeEndedAnimator.animate()
            .subscribe(onCompleted: { self.onTimeEndedAnimatorCompleted() })
            .disposed(by: disposeBag)
    }
    
    private func onTimeEndedAnimatorCompleted() {
        viewModel.timeEndedAnimationsCompleted()
    }
    
    private func onHighScoreBeaten() {
        highScoreBeatenAnimator.animate()
    }
    
    private func hideScore() {
        mainView.hideScore()
    }
    
    private func hideHighScoreBeatenMessage() {
        mainView.hideHighScoreBeatenMessage()
    }
    
    private func updateBackgroundColor(tap: UserTap) {
        colorGenerator.generate()
        mainView.updateBackground(color: colorGenerator.color,
                                  tapPoint: tap.location)
    }
}

