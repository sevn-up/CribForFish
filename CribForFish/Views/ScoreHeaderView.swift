import SwiftUI

struct ScoreHeaderView: View {
    let players: [PlayerState]
    let activeIndex: Int
    var onSelectPlayer: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<players.count, id: \.self) { idx in
                Button {
                    onSelectPlayer?(idx)
                } label: {
                    VStack(spacing: 2) {
                        Text(players[idx].name)
                            .font(.caption)
                            .foregroundStyle(players[idx].color.color)

                        Text("\(players[idx].score)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(players[idx].color.color)
                            .contentTransition(.numericText())

                        // Triangle indicator under active player
                        if idx == activeIndex {
                            Image(systemName: "arrowtriangle.up.fill")
                                .font(.system(size: 6))
                                .foregroundStyle(players[idx].color.color)
                        } else {
                            Color.clear.frame(height: 6)
                        }
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
                .buttonStyle(.plain)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: activeIndex)
        .background(BoardTheme.headerBackground)
    }
}
