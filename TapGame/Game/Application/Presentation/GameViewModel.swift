
import RxSwift
import RxCocoa

class GameViewModel {

    private let secondsLeftTimer = Observable<Int>.countdownTimer(from: 15, to: 0)
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
    
    private let highScoreRepository: HighScoreRepository
    private let disposeBag = DisposeBag()
    
    private let userTapsSubject = PublishSubject<Void>()
    var userTapsObserver: AnyObserver<Void> { return userTapsSubject.asObserver() }
    
    init(highScoreRepository: HighScoreRepository) {
        
        self.highScoreRepository = highScoreRepository
        
        observeScore()
        observeUserTaps()
    }
    
    func observeUserTaps() {
        
        userTapsSubject
            .take(1)
            .subscribe(onNext: { [weak self] in self?.firstUserTapReceived() })
            .disposed(by: disposeBag)
        
        userTapsSubject
            .takeUntil(timeEnded)
            .subscribe(onNext: { [weak self] in self?.userTapReceived() })
            .disposed(by: disposeBag)
    }
    
    func firstUserTapReceived() {
        observeSecondsLeftTimer()
        
        scoreHiddenSubject.onNext(false)
        startTappingMessageHiddenSubject.onNext(true)
    }
    
    func userTapReceived() {
        scoreSubject.onNext(getCurrentScore() + 1)
    }
    
    func timeEndedAnimationsCompleted() {
        completedSubject.onNext(getCurrentScore())
        completedSubject.onCompleted()
    }
    
    private func observeScore() {
        
        guard let highScore = highScoreRepository.getHighScore() else {
            return
        }
        
        score
            .filter({ highScore < $0 })
            .take(1)
            .subscribe(highScoreBeatenSubject)
            .disposed(by: disposeBag)
    }
    
    private func getCurrentScore() -> Int {
        return (try? scoreSubject.value()) ?? 0
    }
    
    private func observeSecondsLeftTimer() {
        
        secondsLeftTimer
            .subscribe(onNext: { self.onSecondsLeftNext($0) },
                       onCompleted: { self.onSecondsLeftCompleted() })
            .disposed(by: disposeBag)
    }
    
    private func onSecondsLeftNext(_ secondsLeft: Int) {
        secondsLeftSubject.onNext(secondsLeft)
    }
    
    private func onSecondsLeftCompleted() {
        
        let highScore = highScoreRepository.getHighScore() ?? 0
        let score = getCurrentScore()
        
        if highScore < score {
            highScoreRepository.saveHighScore(score)
        }
                
        timeEndSubject.onNext(Void())
        timeEndSubject.onCompleted()
    }
}
