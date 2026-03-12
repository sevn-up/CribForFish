import Foundation
import SwiftData

@Model
final class GameRecord {
    var date: Date
    var playerNames: [String]
    var playerColorIndices: [Int]
    var finalScores: [Int]
    var winnerName: String
    var winnerIndex: Int
    var playerCount: Int
    var movesData: Data
    var tournamentID: String?

    init(players: [PlayerState], moves: [Move], winnerIndex: Int) {
        self.date = Date()
        self.playerNames = players.map(\.name)
        self.playerColorIndices = players.map(\.colorIndex)
        self.finalScores = players.map(\.frontPeg)
        self.winnerIndex = winnerIndex
        self.winnerName = players[winnerIndex].name
        self.playerCount = players.count
        self.movesData = (try? JSONEncoder().encode(moves)) ?? Data()
    }

    var moves: [Move] {
        (try? JSONDecoder().decode([Move].self, from: movesData)) ?? []
    }
}
