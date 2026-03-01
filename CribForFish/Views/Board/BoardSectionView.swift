import SwiftUI

/// One "street" of the cribbage board: two columns (up + down) = 60 holes with a turnaround.
struct BoardSectionView: View {
    let section: Int
    let players: [PlayerState]

    var body: some View {
        VStack(spacing: 0) {
            // Section label
            HStack(spacing: 4) {
                Image(systemName: "water.waves")
                    .font(.caption2)
                Text(section == 0 ? "Shallows (1–60)" : "Deep Water (61–120)")
                    .font(.caption2)
            }
            .foregroundStyle(OceanTheme.secondaryText)
            .padding(.bottom, 4)

            HStack(alignment: .top, spacing: 16) {
                // Left column (ascending)
                ColumnView(section: section, column: 0, players: players)

                // Divider line
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1)

                // Right column (descending)
                ColumnView(section: section, column: 1, players: players)
            }

            // Turnaround indicator
            HStack(spacing: 2) {
                Image(systemName: "water.waves")
                    .font(.caption2)
                    .foregroundStyle(OceanTheme.secondaryText)
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(OceanTheme.sectionBackground)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
        )
    }
}
