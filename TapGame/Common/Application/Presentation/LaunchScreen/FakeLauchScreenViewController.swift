
import UIKit

protocol FakeLaunchScreenViewControllerDelegate: class {
    
    func loadingCompleted()
}

class FakeLaunchScreenViewController: UIViewController {

    weak var delegate: FakeLaunchScreenViewControllerDelegate?
    
    lazy var mainView = LaunchScreenView.loadNib()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        simulateBackgroundProcess()
    }
    
    private func simulateBackgroundProcess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.delegate?.loadingCompleted()
        }
    }
}
