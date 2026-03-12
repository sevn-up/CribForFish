import SwiftUI

struct GameHistoryListView: View {
    let records: [GameRecord]

    var body: some View {
        List {
            ForEach(records) { record in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(PlayerColor(rawValue: record.playerColorIndices[record.winnerIndex])?.color ?? .white)
                        Text("\(record.winnerName) won")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text(record.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(BoardTheme.secondaryText)
                    }

                    HStack(spacing: 16) {
                        ForEach(0..<record.playerCount, id: \.self) { idx in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(PlayerColor(rawValue: record.playerColorIndices[idx])?.color ?? .white)
                                    .frame(width: 8, height: 8)
                                Text("\(record.playerNames[idx]): \(record.finalScores[idx])")
                                    .font(.caption)
                                    .foregroundStyle(BoardTheme.secondaryText)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(BoardTheme.sectionBackground)
            }
        }
        .scrollContentBackground(.hidden)
        .background(BoardTheme.headerBackground)
        .navigationTitle("Game History")
    }
}
