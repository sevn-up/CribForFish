import Foundation

struct PlayerStats {
    let name: String
    let gamesPlayed: Int
    let wins: Int
    let losses: Int
    let averageScore: Double
    let highScore: Int
    let currentStreak: Int // positive = win streak, negative = loss streak

    var winRate: Double {
        gamesPlayed > 0 ? Double(wins) / Double(gamesPlayed) : 0
    }

    static func compute(for playerName: String, from records: [GameRecord]) -> PlayerStats {
        let relevant = records.filter { $0.playerNames.contains(playerName) }
        guard !relevant.isEmpty else {
            return PlayerStats(name: playerName, gamesPlayed: 0, wins: 0, losses: 0,
                               averageScore: 0, highScore: 0, currentStreak: 0)
        }

        var wins = 0
        var scores: [Int] = []
        var streakResults: [Bool] = [] // true = win

        for record in relevant.sorted(by: { $0.date < $1.date }) {
            guard let idx = record.playerNames.firstIndex(of: playerName) else { continue }
            let score = record.finalScores[idx]
            scores.append(score)
            let won = record.winnerName == playerName
            if won { wins += 1 }
            streakResults.append(won)
        }

        // Calculate current streak
        var streak = 0
        for result in streakResults.reversed() {
            if streakResults.last == result {
                streak += result ? 1 : -1
            } else {
                break
            }
        }

        return PlayerStats(
            name: playerName,
            gamesPlayed: relevant.count,
            wins: wins,
            losses: relevant.count - wins,
            averageScore: scores.isEmpty ? 0 : Double(scores.reduce(0, +)) / Double(scores.count),
            highScore: scores.max() ?? 0,
            currentStreak: streak
        )
    }

    static func headToHead(player1: String, player2: String, from records: [GameRecord], playerCount: Int? = nil) -> (p1Wins: Int, p2Wins: Int, games: Int) {
        var shared = records.filter {
            $0.playerNames.contains(player1) && $0.playerNames.contains(player2)
        }
        if let playerCount {
            shared = shared.filter { $0.playerCount == playerCount }
        }
        let p1Wins = shared.filter { $0.winnerName == player1 }.count
        let p2Wins = shared.filter { $0.winnerName == player2 }.count
        return (p1Wins, p2Wins, shared.count)
    }
}
