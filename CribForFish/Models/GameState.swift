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
    var dealerIndex: Int = 0
    var playerProfileIDs: [String] = []
    var recorded: Bool = false

    init(playerCount: Int = 3, players: [PlayerState]? = nil, profileIDs: [String] = []) {
        self.playerCount = playerCount
        let defaultPlayers = players ?? {
            let names = ["Marlin", "Tuna", "Salmon"]
            return (0..<playerCount).map { i in
                PlayerState(name: names[i], colorIndex: i, frontPeg: 0, backPeg: 0)
            }
        }()
        self.playersData = (try? JSONEncoder().encode(defaultPlayers)) ?? Data()
        self.movesData = (try? JSONEncoder().encode([Move]())) ?? Data()
        self.activePlayerIndex = 0
        self.isGameOver = false
        self.lastModified = Date()
        self.dealerIndex = 0
        self.playerProfileIDs = profileIDs
        self.recorded = false
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
