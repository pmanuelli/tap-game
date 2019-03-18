
import Foundation

class Game {
    
    private(set) var score = 0
    private(set) var scoreIsHighScore = false
    
    private var secondsLeft: Int
    private var initialHighScore: Int
    
    init(secondsLeft: Int, initialHighScore: Int) {
        self.secondsLeft = secondsLeft
        self.initialHighScore = initialHighScore
    }
    
    func tap() {
        
        if secondsLeft > 0 {
            score += 1
            scoreIsHighScore = score > initialHighScore
        }
    }
    
    func secondElapsed() {
        secondsLeft -= 1
    }
}
