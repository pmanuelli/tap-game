
import UIKit

extension UIView {
    
    func addSubviewToBounds(_ view: UIView) {
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}
