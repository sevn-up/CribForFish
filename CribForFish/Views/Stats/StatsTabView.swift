import SwiftUI
import SwiftData

struct StatsTabView: View {
    @Query(sort: \GameRecord.date, order: .reverse) private var records: [GameRecord]
    @Query(sort: \PlayerProfile.createdAt) private var profiles: [PlayerProfile]

    var body: some View {
        NavigationStack {
            List {
                if records.isEmpty {
                    ContentUnavailableView(
                        "No Games Yet",
                        systemImage: "chart.bar",
                        description: Text("Complete a game to see your stats here.")
                    )
                } else {
                    Section("Players") {
                        ForEach(uniquePlayerNames, id: \.self) { name in
                            let stats = PlayerStats.compute(for: name, from: records)
                            NavigationLink {
                                PlayerStatsView(stats: stats, records: records)
                            } label: {
                                HStack {
                                    Text(name)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("\(stats.wins)W - \(stats.losses)L")
                                        .font(.caption)
                                        .foregroundStyle(BoardTheme.secondaryText)
                                }
                            }
                        }
                    }

                    Section("Head to Head") {
                        ForEach(playerPairs, id: \.id) { pair in
                            NavigationLink {
                                HeadToHeadView(
                                    player1: pair.p1,
                                    player2: pair.p2,
                                    records: records
                                )
                            } label: {
                                let h2h = PlayerStats.headToHead(player1: pair.p1, player2: pair.p2, from: records)
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text("\(pair.p1) vs \(pair.p2)")
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text("\(h2h.p1Wins) - \(h2h.p2Wins)")
                                            .font(.caption)
                                            .foregroundStyle(BoardTheme.secondaryText)
                                    }
                                    let breakdown = playerCountBreakdown(p1: pair.p1, p2: pair.p2)
                                    if breakdown.count > 1 {
                                        Text(breakdown.map { "\($0.count)P: \($0.p1W)-\($0.p2W)" }.joined(separator: " · "))
                                            .font(.caption2)
                                            .foregroundStyle(BoardTheme.secondaryText.opacity(0.7))
                                    }
                                }
                            }
                        }
                    }

                    Section {
                        NavigationLink {
                            GameHistoryListView(records: records)
                        } label: {
                            Label("Game History", systemImage: "clock")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BoardTheme.headerBackground)
            .navigationTitle("Stats")
        }
    }

    private var uniquePlayerNames: [String] {
        var seen = Set<String>()
        var names: [String] = []
        for record in records {
            for name in record.playerNames {
                if seen.insert(name).inserted {
                    names.append(name)
                }
            }
        }
        return names
    }

    private func playerCountBreakdown(p1: String, p2: String) -> [(count: Int, p1W: Int, p2W: Int)] {
        let shared = records.filter { $0.playerNames.contains(p1) && $0.playerNames.contains(p2) }
        let counts = Set(shared.map(\.playerCount)).sorted()
        return counts.compactMap { pc in
            let h2h = PlayerStats.headToHead(player1: p1, player2: p2, from: records, playerCount: pc)
            guard h2h.games > 0 else { return nil }
            return (count: pc, p1W: h2h.p1Wins, p2W: h2h.p2Wins)
        }
    }

    private var playerPairs: [PlayerPair] {
        let names = uniquePlayerNames
        var pairs: [PlayerPair] = []
        for i in 0..<names.count {
            for j in (i+1)..<names.count {
                let h2h = PlayerStats.headToHead(player1: names[i], player2: names[j], from: records)
                if h2h.games > 0 {
                    pairs.append(PlayerPair(p1: names[i], p2: names[j]))
                }
            }
        }
        return pairs
    }
}

private struct PlayerPair: Identifiable {
    let p1: String
    let p2: String
    var id: String { "\(p1)-\(p2)" }
}
