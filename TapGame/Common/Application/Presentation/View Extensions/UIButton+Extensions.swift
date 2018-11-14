
import UIKit

extension UIButton {

    func title() -> String {
        return title(for: .normal) ?? ""
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
