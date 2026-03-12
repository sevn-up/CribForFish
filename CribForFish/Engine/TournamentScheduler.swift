import Foundation

enum TournamentScheduler {
    /// Generates a round-robin schedule for N players.
    /// Each player plays every other player exactly once.
    /// Odd player counts get a "BYE" opponent in each round.
    static func generateSchedule(
        playerNames: [String],
        playerColorIndices: [Int]
    ) -> [TournamentMatch] {
        var names = playerNames
        var colors = playerColorIndices

        // For odd player counts, add a BYE placeholder
        let hasBye = names.count % 2 != 0
        if hasBye {
            names.append("BYE")
            colors.append(0)
        }

        let n = names.count
        let roundCount = n - 1
        var matches: [TournamentMatch] = []

        // Circle method for round-robin scheduling
        // Fix player 0, rotate the rest
        var rotation = Array(1..<n)

        for round in 0..<roundCount {
            let allPlayers = [0] + rotation

            for i in 0..<(n / 2) {
                let p1Idx = allPlayers[i]
                let p2Idx = allPlayers[n - 1 - i]

                var match = TournamentMatch(
                    round: round,
                    player1Name: names[p1Idx],
                    player2Name: names[p2Idx],
                    player1ColorIndex: colors[p1Idx],
                    player2ColorIndex: colors[p2Idx]
                )

                // Auto-complete bye matches
                if match.isBye {
                    match.isComplete = true
                    match.winnerName = match.player1Name
                }

                matches.append(match)
            }

            // Rotate: move last element to front
            rotation.insert(rotation.removeLast(), at: 0)
        }

        return matches
    }
}
