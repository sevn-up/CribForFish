import Foundation

struct Move: Codable, Equatable {
    let playerIndex: Int
    let points: Int
    let previousFrontPeg: Int
    let previousBackPeg: Int
}
