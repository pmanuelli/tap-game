
import UIKit

class RippleEffectView: UIView {

    func touchIn(point: CGPoint, newColor: UIColor) {

        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

        subview.center = point
        subview.clipsToBounds = true
        subview.backgroundColor = newColor
        subview.cornerRadius = subview.bounds.height / 2
        
        addSubview(subview)
        
        UIView.animate(withDuration: 0.75, animations: {
            subview.transform = CGAffineTransform(scale: 150)
        }) { _ in
            self.backgroundColor = newColor
            subview.removeFromSuperview()
        }
    }
}
