import Foundation

struct PlayerState: Codable, Equatable {
    var name: String
    var colorIndex: Int
    var frontPeg: Int  // current score position (0 = start)
    var backPeg: Int   // previous score position (0 = start)

    var color: PlayerColor {
        PlayerColor(rawValue: colorIndex) ?? .coral
    }

    var hasWon: Bool {
        frontPeg >= 121
    }

    var score: Int {
        frontPeg
    }
}
