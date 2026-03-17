import SwiftUI

struct PlayerSelectorView: View {
    let players: [PlayerState]
    let activeIndex: Int
    var dealerIndex: Int = 0
    let onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<players.count, id: \.self) { idx in
                Button {
                    onSelect(idx)
                } label: {
                    HStack(spacing: 4) {
                        Text(players[idx].name)
                            .font(.subheadline)
                            .fontWeight(idx == activeIndex ? .bold : .regular)

                        if idx == dealerIndex {
                            Text("D")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 16, height: 16)
                                .background(Circle().fill(players[idx].color.color.opacity(0.6)))
                        }
                    }
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
