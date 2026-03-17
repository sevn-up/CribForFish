import SwiftUI
import Charts

struct HeadToHeadView: View {
    let player1: String
    let player2: String
    let records: [GameRecord]

    private var h2h: (p1Wins: Int, p2Wins: Int, games: Int) {
        PlayerStats.headToHead(player1: player1, player2: player2, from: records)
    }

    private var sharedRecords: [GameRecord] {
        records.filter {
            $0.playerNames.contains(player1) && $0.playerNames.contains(player2)
        }.sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    HStack {
                        VStack {
                            Text("\(h2h.p1Wins)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(.green)
                            Text(player1)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)

                        Text("vs")
                            .font(.title3)
                            .foregroundStyle(BoardTheme.secondaryText)

                        VStack {
                            Text("\(h2h.p2Wins)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(.blue)
                            Text(player2)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    if h2h.games > 0 {
                        GeometryReader { geo in
                            HStack(spacing: 2) {
                                Rectangle()
                                    .fill(.green)
                                    .frame(width: geo.size.width * CGFloat(h2h.p1Wins) / CGFloat(h2h.games))
                                Rectangle()
                                    .fill(.blue)
                            }
                            .clipShape(Capsule())
                        }
                        .frame(height: 8)
                    }

                    Text("\(h2h.games) games played")
                        .font(.caption)
                        .foregroundStyle(BoardTheme.secondaryText)
                }
                .padding(.vertical, 8)
                .listRowBackground(BoardTheme.sectionBackground)
            }

            Section("Match History") {
                ForEach(sharedRecords) { record in
                    HStack {
                        let p1Idx = record.playerNames.firstIndex(of: player1) ?? 0
                        let p2Idx = record.playerNames.firstIndex(of: player2) ?? 1
                        Text("\(record.finalScores[p1Idx])")
                            .font(.headline)
                            .foregroundStyle(record.winnerName == player1 ? .green : BoardTheme.secondaryText)
                            .frame(maxWidth: .infinity)

                        Text("-")
                            .foregroundStyle(BoardTheme.secondaryText)

                        Text("\(record.finalScores[p2Idx])")
                            .font(.headline)
                            .foregroundStyle(record.winnerName == player2 ? .blue : BoardTheme.secondaryText)
                            .frame(maxWidth: .infinity)

                        Text("\(record.playerCount)P")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(BoardTheme.accent)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(BoardTheme.accent.opacity(0.15))
                            )

                        Text(record.date, style: .date)
                            .font(.caption2)
                            .foregroundStyle(BoardTheme.secondaryText)
                    }
                    .listRowBackground(BoardTheme.sectionBackground)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(BoardTheme.headerBackground)
        .navigationTitle("\(player1) vs \(player2)")
    }
}
