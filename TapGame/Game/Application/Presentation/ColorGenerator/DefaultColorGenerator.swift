
import UIKit

class DefaultColorGenerator: ColorGenerator {
    
    var color: UIColor { return colors[colorIndex] }
    
    private let colors: [UIColor] = [
        UIColor(r: 237, g: 12, b: 25),
        UIColor(r: 187, g: 9, b: 57),
        UIColor(r: 173, g: 9, b: 70),
        UIColor(r: 164, g: 11, b: 92),
        UIColor(r: 139, g: 11, b: 101),
        UIColor(r: 105, g: 11, b: 107),
        UIColor(r: 69, g: 11, b: 112),
        UIColor(r: 41, g: 11, b: 116),
        UIColor(r: 3, g: 12, b: 126),
        UIColor(r: 4, g: 50, b: 112),
        UIColor(r: 7, g: 76, b: 101),
        UIColor(r: 8, g: 88, b: 76),
        UIColor(r: 15, g: 127, b: 19),
        UIColor(r: 83, g: 171, b: 30),
        UIColor(r: 140, g: 186, b: 35),
        UIColor(r: 185, g: 205, b: 42),
        UIColor(r: 248, g: 232, b: 52),
        UIColor(r: 244, g: 174, b: 41),
        UIColor(r: 243, g: 132, b: 35),
        UIColor(r: 241, g: 99, b: 31),
        UIColor(r: 239, g: 75, b: 29),
        UIColor(r: 239, g: 55, b: 29),
        UIColor(r: 237, g: 35, b: 26),
        UIColor(r: 237, g: 24, b: 25)
    ]
    
    private var colorIndex = 0
    
    func generate() {
        colorIndex = (colorIndex + 1) % colors.count
    }
}
