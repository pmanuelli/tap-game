
import UIKit

extension UIView {
        
    @IBInspectable
    var shadowColor: UIColor? {
        get { return getShadowColor() }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue)}
    }
    
    private func getShadowColor() -> UIColor? {
        
        if let color = layer.shadowColor {
            return UIColor(cgColor: color)
        } else {
            return nil
        }
    }
}
