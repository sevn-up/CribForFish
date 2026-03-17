import SwiftUI
import Charts

struct PlayerStatsView: View {
    let stats: PlayerStats
    let records: [GameRecord]

    var body: some View {
        List {
            Section("Overview") {
                statRow("Games Played", value: "\(stats.gamesPlayed)")
                statRow("Wins", value: "\(stats.wins)")
                statRow("Losses", value: "\(stats.losses)")
                statRow("Win Rate", value: String(format: "%.0f%%", stats.winRate * 100))
                statRow("Average Score", value: String(format: "%.1f", stats.averageScore))
                statRow("High Score", value: "\(stats.highScore)")
                statRow("Current Streak", value: streakText)
            }

            if stats.gamesPlayed >= 2 {
                Section("Score History") {
                    Chart(scoreHistory) { entry in
                        LineMark(
                            x: .value("Game", entry.gameNumber),
                            y: .value("Score", entry.score)
                        )
                        .foregroundStyle(BoardTheme.accent)
                        PointMark(
                            x: .value("Game", entry.gameNumber),
                            y: .value("Score", entry.score)
                        )
                        .foregroundStyle(entry.won ? Color.green : Color.red)
                    }
                    .frame(height: 200)
                    .chartYScale(domain: 0...121)
                    .listRowBackground(BoardTheme.sectionBackground)
                }
            }

            Section("Recent Games") {
                ForEach(playerRecords.prefix(10)) { record in
                    if let idx = record.playerNames.firstIndex(of: stats.name) {
                        HStack {
                            Image(systemName: record.winnerName == stats.name ? "trophy.fill" : "xmark.circle")
                                .foregroundStyle(record.winnerName == stats.name ? .yellow : BoardTheme.secondaryText)
                            VStack(alignment: .leading) {
                                Text(record.playerNames.joined(separator: " vs "))
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                Text(record.date, style: .date)
                                    .font(.caption2)
                                    .foregroundStyle(BoardTheme.secondaryText)
                            }
                            Spacer()
                            Text("\(record.finalScores[idx])")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .listRowBackground(BoardTheme.sectionBackground)
            }
        }
        .scrollContentBackground(.hidden)
        .background(BoardTheme.headerBackground)
        .navigationTitle(stats.name)
    }

    private var streakText: String {
        if stats.currentStreak > 0 {
            return "\(stats.currentStreak)W"
        } else if stats.currentStreak < 0 {
            return "\(abs(stats.currentStreak))L"
        }
        return "-"
    }

    private var playerRecords: [GameRecord] {
        records.filter { $0.playerNames.contains(stats.name) }
            .sorted { $0.date > $1.date }
    }

    private var scoreHistory: [ScoreEntry] {
        let sorted = records.filter { $0.playerNames.contains(stats.name) }
            .sorted { $0.date < $1.date }
        return sorted.enumerated().compactMap { gameNum, record in
            guard let idx = record.playerNames.firstIndex(of: stats.name) else { return nil }
            return ScoreEntry(
                gameNumber: gameNum + 1,
                score: record.finalScores[idx],
                won: record.winnerName == stats.name
            )
        }
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(BoardTheme.secondaryText)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .listRowBackground(BoardTheme.sectionBackground)
    }
}

private struct ScoreEntry: Identifiable {
    let gameNumber: Int
    let score: Int
    let won: Bool
    var id: Int { gameNumber }
}
