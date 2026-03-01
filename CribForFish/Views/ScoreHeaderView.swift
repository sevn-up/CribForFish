import SwiftUI

struct ScoreHeaderView: View {
    let players: [PlayerState]
    let activeIndex: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<players.count, id: \.self) { idx in
                VStack(spacing: 2) {
                    Text(players[idx].name)
                        .font(.caption)
                        .foregroundStyle(players[idx].color.color)

                    Text("\(players[idx].score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(players[idx].color.color)
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    idx == activeIndex
                        ? players[idx].color.color.opacity(0.15)
                        : Color.clear
                )
                .overlay(alignment: .bottom) {
                    if idx == activeIndex {
                        Rectangle()
                            .fill(players[idx].color.color)
                            .frame(height: 2)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: activeIndex)
        .background(OceanTheme.headerBackground)
    }
}
