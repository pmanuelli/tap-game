
import RxSwift
import UIKit

class MainCoordinator {
    
    private let navigationController: UINavigationController
    
    private let highScoreRepository = InMemoryHighScoreRepository()
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        showFakeLauchScreenController()
    }
    
    private func showFakeLauchScreenController() {
        
        let controller = FakeLaunchScreenViewController()
        controller.delegate = self
        
        navigationController.pushViewController(controller, animated: false)
    }
    
    private func startGameViewController() {
        
        let viewModel = GameViewModel(highScoreRepository: highScoreRepository)
        let viewController = GameViewController(viewModel: viewModel)
        
        observeCompleted(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func observeCompleted(viewModel: GameViewModel) {
        
        viewModel.completed
            .subscribe(onSuccess: { self.startGameEndedViewController(score: $0) })
            .disposed(by: disposeBag)
    }
    
    private func startGameEndedViewController(score: Int) {
        
        let viewController = GameResultViewController(score: score)
        
        viewController.mainView.retryButton.addTarget(self, action: #selector(retryButtonTouched), for: .touchUpInside)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func retryButtonTouched() {
        
        startGameViewController()
    }
}

extension MainCoordinator: FakeLaunchScreenViewControllerDelegate {
    
    func loadingCompleted() {
        startGameViewController()
    }
}
