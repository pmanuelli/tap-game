
import RxSwift
import RxCocoa

class GameViewModel {

    private let secondsLeftTimer: Observable<Int>
    private let secondsLeftSubject = PublishSubject<Int>()
    var secondsLeft: Observable<Int> { return secondsLeftSubject.asObservable() }
    
    private let timeEndSubject = PublishSubject<Void>()
    var timeEnded: Observable<Void> { return timeEndSubject.asObservable() }
    
    private let scoreSubject = BehaviorSubject<Int>(value: 0)
    var score: Observable<Int> { return scoreSubject.asObservable() }
    
    private let scoreHiddenSubject = BehaviorSubject<Bool>(value: true)
    var scoreHidden: Driver<Bool> { return scoreHiddenSubject.asDriver(onErrorJustReturn: true) }
    
    private let startTappingMessageHiddenSubject = BehaviorSubject<Bool>(value: false)
    var startTappingMessageHidden: Driver<Bool> { return startTappingMessageHiddenSubject.asDriver(onErrorJustReturn: false) }
    
    private let highScoreBeatenSubject = PublishSubject<Int>()
    var highScoreBeaten: Completable { return highScoreBeatenSubject.ignoreElements() }
    
    private let completedSubject = PublishSubject<Int>()
    var completed: Single<Int> { return completedSubject.asSingle() }
    
    private let userTapsSubject = PublishSubject<Void>()
    var userTapsObserver: AnyObserver<Void> { return userTapsSubject.asObserver() }
    
    private let game: Game
    private let previousHighScore: Int?
    private let highScoreRepository: HighScoreRepository
    
    private let disposeBag = DisposeBag()
    
    init(highScoreRepository: HighScoreRepository) {
        
        self.highScoreRepository = highScoreRepository
        self.previousHighScore = highScoreRepository.find()
        
        let secondsLeft = 15
        self.game = Game(secondsLeft: secondsLeft, initialHighScore: previousHighScore ?? 0)
        self.secondsLeftTimer = Observable<Int>.countdownTimer(from: secondsLeft, to: 0)

        observeUserTaps()
    }
    
    private func observeUserTaps() {
        
        userTapsSubject
            .take(1)
            .subscribe(onNext: { [weak self] in self?.firstUserTapReceived() })
            .disposed(by: disposeBag)
        
        userTapsSubject
            .takeUntil(timeEnded)
            .subscribe(onNext: { [weak self] in self?.userTapReceived() })
            .disposed(by: disposeBag)
    }
    
    private func firstUserTapReceived() {
        startCountDownTimer()
        
        showScore()
        hideStartTappingMessage()
    }
    
    private func showScore() {
        scoreHiddenSubject.onNext(false)
    }
    
    private func hideStartTappingMessage() {
        startTappingMessageHiddenSubject.onNext(true)
    }
    
    private func userTapReceived() {
        game.tap()
        
        changeScore(game.score)
        showHighScoreBeatenIfNeeded(game.scoreIsHighScore)
    }
    
    private func changeScore(_ score: Int) {
        scoreSubject.onNext(score)
    }
    
    private func showHighScoreBeatenIfNeeded(_ highScoreBeaten: Bool) {
        if previousHighScore != nil && highScoreBeaten  {
            highScoreBeatenSubject.onCompleted()
        }
    }
    
    func timeEndedAnimationsCompleted() {
        completedSubject.onNext(game.score)
        completedSubject.onCompleted()
    }
    
    private func startCountDownTimer() {
        
        secondsLeftTimer
            .subscribe(onNext: { self.onSecondsLeftNext($0) },
                       onCompleted: { self.onSecondsLeftCompleted() })
            .disposed(by: disposeBag)
    }
    
    private func onSecondsLeftNext(_ secondsLeft: Int) {
        game.secondElapsed()
        secondsLeftSubject.onNext(secondsLeft)
    }
    
    private func onSecondsLeftCompleted() {
        
        saveHighScore()

        timeEndSubject.onNext(Void())
        timeEndSubject.onCompleted()
    }
    
    private func saveHighScore() {
        
        if game.scoreIsHighScore {
            highScoreRepository.put(game.score)
        }
    }
}
