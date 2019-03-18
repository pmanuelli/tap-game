
import Foundation

protocol HighScoreRepository {
    
    func find() -> Int?
    func put(_ highScore: Int)
}
