import Foundation
import SwiftData

@Model
final class Tournament {
    var name: String
    var playerNames: [String]
    var playerColorIndices: [Int]
    var matchesData: Data
    var createdAt: Date
    var isComplete: Bool

    init(name: String, playerNames: [String], playerColorIndices: [Int], matches: [TournamentMatch]) {
        self.name = name
        self.playerNames = playerNames
        self.playerColorIndices = playerColorIndices
        self.matchesData = (try? JSONEncoder().encode(matches)) ?? Data()
        self.createdAt = Date()
        self.isComplete = false
    }

    var matches: [TournamentMatch] {
        get {
            (try? JSONDecoder().decode([TournamentMatch].self, from: matchesData)) ?? []
        }
        set {
            matchesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var rounds: [[TournamentMatch]] {
        let allMatches = matches
        let roundCount = allMatches.map(\.round).max().map { $0 + 1 } ?? 0
        return (0..<roundCount).map { r in
            allMatches.filter { $0.round == r }
        }
    }

    var standings: [TournamentStanding] {
        let allMatches = matches.filter { $0.isComplete && !$0.isBye }
        return playerNames.enumerated().map { idx, name in
            let wins = allMatches.filter { $0.winnerName == name }.count
            let losses = allMatches.filter {
                ($0.player1Name == name || $0.player2Name == name) && $0.winnerName != name
            }.count

            var pointsFor = 0
            var pointsAgainst = 0
            for match in allMatches {
                if match.player1Name == name {
                    pointsFor += match.player1Score ?? 0
                    pointsAgainst += match.player2Score ?? 0
                } else if match.player2Name == name {
                    pointsFor += match.player2Score ?? 0
                    pointsAgainst += match.player1Score ?? 0
                }
            }

            // Byes count as wins
            let byeWins = matches.filter { $0.isBye && $0.player1Name == name }.count

            return TournamentStanding(
                name: name,
                colorIndex: playerColorIndices[idx],
                wins: wins + byeWins,
                losses: losses,
                pointsFor: pointsFor,
                pointsAgainst: pointsAgainst
            )
        }.sorted { a, b in
            if a.wins != b.wins { return a.wins > b.wins }
            return a.pointDifferential > b.pointDifferential
        }
    }

    func checkCompletion() {
        let playable = matches.filter { !$0.isBye }
        isComplete = playable.allSatisfy(\.isComplete)
    }
}

struct TournamentStanding: Identifiable {
    let name: String
    let colorIndex: Int
    let wins: Int
    let losses: Int
    let pointsFor: Int
    let pointsAgainst: Int

    var id: String { name }
    var pointDifferential: Int { pointsFor - pointsAgainst }

    var color: PlayerColor {
        PlayerColor(rawValue: colorIndex) ?? .red
    }
}
