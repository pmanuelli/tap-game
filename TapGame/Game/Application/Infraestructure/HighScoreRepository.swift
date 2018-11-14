
import Foundation

protocol HighScoreRepository {
    
    func getHighScore() -> Int?
    func saveHighScore(_ highScore: Int)
}

class InMemoryHighScoreRepository: HighScoreRepository {
    
    var highScore: Int?
    
    func getHighScore() -> Int? {
        return highScore
    }
    
    func saveHighScore(_ highScore: Int) {
        self.highScore = highScore
    }
}
