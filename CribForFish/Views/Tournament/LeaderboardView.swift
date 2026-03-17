import SwiftUI

struct LeaderboardView: View {
    let standings: [TournamentStanding]

    var body: some View {
        ForEach(Array(standings.enumerated()), id: \.element.id) { rank, standing in
            HStack(spacing: 12) {
                Text("#\(rank + 1)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(rank == 0 ? .yellow : BoardTheme.secondaryText)
                    .frame(width: 28)

                Circle()
                    .fill(standing.color.color)
                    .frame(width: 10, height: 10)

                Text(standing.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()

                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(standing.wins)W - \(standing.losses)L")
                        .font(.caption)
                        .foregroundStyle(.white)
                    Text("\(standing.pointsFor)pts (diff: \(standing.pointDifferential > 0 ? "+" : "")\(standing.pointDifferential))")
                        .font(.caption2)
                        .foregroundStyle(BoardTheme.secondaryText)
                }
            }
            .listRowBackground(BoardTheme.sectionBackground)
        }
    }
}
