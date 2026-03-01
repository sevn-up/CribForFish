import SwiftUI

struct PlayerSelectorView: View {
    let players: [PlayerState]
    let activeIndex: Int
    let onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<players.count, id: \.self) { idx in
                Button {
                    onSelect(idx)
                } label: {
                    Text(players[idx].name)
                        .font(.subheadline)
                        .fontWeight(idx == activeIndex ? .bold : .regular)
                        .foregroundStyle(idx == activeIndex ? .white : players[idx].color.color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(idx == activeIndex ? players[idx].color.color : players[idx].color.color.opacity(0.2))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
