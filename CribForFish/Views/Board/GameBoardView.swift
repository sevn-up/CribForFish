import SwiftUI

struct GameBoardView: View {
    let players: [PlayerState]
    let leadingHole: Int

    var body: some View {
        VStack(spacing: 0) {
            startArea
                .padding(.vertical, 4)

            HStack(alignment: .top, spacing: 0) {
                // 1st Street — labels on left edge, dots toward center
                streetColumn(startHole: 1, labelsOnLeft: true)

                // Vertical divider
                Rectangle()
                    .fill(BoardTheme.accent.opacity(0.25))
                    .frame(width: 1.5)
                    .padding(.top, 14)

                // 2nd Street — dots toward center, labels on right edge
                streetColumn(startHole: 61, labelsOnLeft: false)
            }
            .padding(.horizontal, 8)

            finishArea
                .padding(.vertical, 4)
        }
        .background(BoardTheme.boardGradient)
    }

    // MARK: - Street Column

    private func streetColumn(startHole: Int, labelsOnLeft: Bool) -> some View {
        VStack(spacing: 0) {
            // Street header
            HStack(spacing: 3) {
                Image(systemName: "road.lanes")
                    .font(.system(size: 7))
                    .foregroundStyle(BoardTheme.accent.opacity(0.6))
                Text(startHole == 1 ? "1st Street" : "2nd Street")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(BoardTheme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 2)

            // 12 groups of 5 holes — distributed evenly
            ForEach(0..<12, id: \.self) { group in
                holeGroup(
                    startHole: startHole + group * 5,
                    labelsOnLeft: labelsOnLeft
                )
                .frame(maxHeight: .infinity)

                // Thin separator line between groups (not after last)
                if group < 11 {
                    let lastHoleInGroup = startHole + group * 5 + 4
                    let isSkunkLine = lastHoleInGroup == 90
                    let isDoubleSkunkLine = lastHoleInGroup == 60

                    if isSkunkLine || isDoubleSkunkLine {
                        skunkMarker(
                            label: isDoubleSkunkLine ? "S×2" : "S",
                            labelsOnLeft: labelsOnLeft
                        )
                    } else {
                        Rectangle()
                            .fill(BoardTheme.accent.opacity(0.08))
                            .frame(height: 0.5)
                            .padding(.horizontal, 8)
                    }
                }
            }

            // Double skunk marker at bottom of 1st Street (after hole 60)
            if startHole == 1 {
                skunkMarker(label: "S×2", labelsOnLeft: labelsOnLeft)
            }
        }
    }

    private func holeGroup(startHole: Int, labelsOnLeft: Bool) -> some View {
        let endHole = startHole + 4

        return HStack(spacing: 3) {
            if labelsOnLeft {
                groupLabel(endHole)
            }

            VStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { i in
                    HoleRowView(holeNumber: startHole + i, players: players)
                        .frame(maxHeight: .infinity)
                }
            }

            if !labelsOnLeft {
                groupLabel(endHole)
            }
        }
    }

    private func groupLabel(_ hole: Int) -> some View {
        Text("\(hole)")
            .font(.system(size: 8, design: .monospaced))
            .foregroundStyle(BoardTheme.secondaryText.opacity(0.5))
            .frame(width: 18)
    }

    private func skunkMarker(label: String, labelsOnLeft: Bool) -> some View {
        HStack(spacing: 2) {
            if !labelsOnLeft { Spacer() }
            Rectangle()
                .fill(Color.red.opacity(0.35))
                .frame(height: 1)
            Text(label)
                .font(.system(size: 6, weight: .bold))
                .foregroundStyle(Color.red.opacity(0.5))
            Rectangle()
                .fill(Color.red.opacity(0.35))
                .frame(height: 1)
            if labelsOnLeft { Spacer() }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Start / Finish

    private var startArea: some View {
        HStack(spacing: 8) {
            Image(systemName: "flag.fill")
                .font(.caption2)
                .foregroundStyle(BoardTheme.secondaryText)

            Text("START")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(BoardTheme.secondaryText)

            HStack(spacing: 5) {
                ForEach(0..<players.count, id: \.self) { idx in
                    Circle()
                        .fill(players[idx].frontPeg == 0 ? players[idx].color.color : Color.white.opacity(0.15))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(BoardTheme.sectionBackground)
        )
    }

    private var finishArea: some View {
        HStack(spacing: 6) {
            Image(systemName: "trophy.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(.yellow)

            Text("FINISH")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(BoardTheme.primaryText)

            HStack(spacing: 5) {
                ForEach(0..<players.count, id: \.self) { idx in
                    Circle()
                        .fill(players[idx].frontPeg >= 121 ? players[idx].color.color : BoardTheme.emptyHole)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(players[idx].color.color.opacity(0.3), lineWidth: 1)
                        )
                }
            }

            Text("121")
                .font(.system(size: 8))
                .foregroundStyle(BoardTheme.secondaryText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(BoardTheme.sectionBackground)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
        )
    }
}
