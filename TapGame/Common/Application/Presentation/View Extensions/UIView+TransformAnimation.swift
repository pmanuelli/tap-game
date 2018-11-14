import UIKit

extension UIView {
    
    struct AnimateTransformData {
        
        let transform: CGAffineTransform
        let duration: TimeInterval
        let delay: TimeInterval
        let options: UIViewAnimationOptions
        
        init(transform: CGAffineTransform, duration: TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = []) {
            
            self.transform = transform
            self.duration = duration
            self.delay = delay
            self.options = options
        }
    }
    
    static func animate(_ view: UIView, data: [AnimateTransformData], completion: (() -> Void)? = nil) {
        
        guard let currentData = data.first else {
            completion?()
            return
        }
        
        UIView.animate(withDuration: currentData.duration, delay: currentData.delay, options: currentData.options, animations: {
            view.transform = currentData.transform
        }) { _ in
            
            let remainingData = Array(data.dropFirst())
            animate(view, data: remainingData, completion: completion)
        }
    }
}
