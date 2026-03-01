import SwiftUI

struct HoleDotView: View {
    let holeNumber: Int
    let playerIndex: Int
    let players: [PlayerState]

    private var pegState: PegState {
        let player = players[playerIndex]
        if player.frontPeg == holeNumber {
            return .front
        } else if player.backPeg == holeNumber && player.backPeg > 0 {
            return .back
        }
        return .empty
    }

    private var color: Color {
        players[playerIndex].color.color
    }

    var body: some View {
        Circle()
            .fill(dotFill)
            .frame(width: dotSize, height: dotSize)
            .overlay {
                if pegState == .empty {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                } else {
                    Circle()
                        .stroke(color.opacity(0.5), lineWidth: 1)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: pegState)
    }

    private var dotSize: CGFloat {
        switch pegState {
        case .front: 16
        case .back: 12
        case .empty: 8
        }
    }

    private var dotFill: Color {
        switch pegState {
        case .front: color
        case .back: color.opacity(0.6)
        case .empty: OceanTheme.emptyHole
        }
    }

    private enum PegState: Equatable {
        case front, back, empty
    }
}
