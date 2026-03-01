import Foundation
import SwiftData

@Model
final class GameState {
    var playersData: Data
    var movesData: Data
    var activePlayerIndex: Int
    var isGameOver: Bool
    var lastModified: Date
    var playerCount: Int

    init(playerCount: Int = 3) {
        self.playerCount = playerCount
        let names = ["Marlin", "Tuna", "Salmon"]
        let defaultPlayers = (0..<playerCount).map { i in
            PlayerState(name: names[i], colorIndex: i, frontPeg: 0, backPeg: 0)
        }
        self.playersData = (try? JSONEncoder().encode(defaultPlayers)) ?? Data()
        self.movesData = (try? JSONEncoder().encode([Move]())) ?? Data()
        self.activePlayerIndex = 0
        self.isGameOver = false
        self.lastModified = Date()
    }

    var players: [PlayerState] {
        get {
            (try? JSONDecoder().decode([PlayerState].self, from: playersData)) ?? []
        }
        set {
            playersData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var moves: [Move] {
        get {
            (try? JSONDecoder().decode([Move].self, from: movesData)) ?? []
        }
        set {
            movesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
}
