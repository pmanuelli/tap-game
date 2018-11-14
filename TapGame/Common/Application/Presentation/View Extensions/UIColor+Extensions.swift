
import UIKit

extension UIColor {
    
    convenience init(r red: Int, g green: Int, b blue: Int, a alpha: Int = 255) {
        
        func convert(_ value: Int) -> CGFloat {
            return CGFloat(min(255, max(0, value))) / 255
        }
        
        self.init(red: convert(red),
                  green: convert(green),
                  blue: convert(blue),
                  alpha: convert(alpha))
    }
}
