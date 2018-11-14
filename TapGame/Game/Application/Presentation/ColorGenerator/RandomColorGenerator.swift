
import UIKit

class RandomColorGenerator: ColorGenerator {

    private(set) var color: UIColor = .white
    
    init() {
        generate()
    }
    
    func generate() {
    
        func randomNumber() -> Int {
            return Int(arc4random_uniform(256))
        }
        
        color = UIColor(r: randomNumber(), g: randomNumber(), b: randomNumber())
    }
}
