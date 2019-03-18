
import Foundation

class InMemoryHighScoreRepository: HighScoreRepository {
    
    var highScore: Int?
    
    func find() -> Int? {
        return highScore
    }
    
    func put(_ highScore: Int) {
        self.highScore = highScore
    }
}
