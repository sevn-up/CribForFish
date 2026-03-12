import SwiftUI

struct GameBoardView: View {
    let players: [PlayerState]
    let leadingHole: Int

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Start area
                    startArea
                        .id("start")

                    // First street (holes 1-60)
                    BoardSectionView(section: 0, players: players)
                        .id("section0")

                    // Second street (holes 61-120)
                    BoardSectionView(section: 1, players: players)
                        .id("section1")

                    // Winning hole 121
                    winningHole
                        .id("win")
                }
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    scrollToLeadingHole(proxy: proxy, animated: false)
                }
            }
            .onChange(of: leadingHole) {
                scrollToLeadingHole(proxy: proxy, animated: true)
            }
        }
        .background(BoardTheme.boardGradient)
    }

    private func scrollToLeadingHole(proxy: ScrollViewProxy, animated: Bool) {
        let action = {
            if leadingHole >= 121 {
                proxy.scrollTo("win", anchor: .center)
            } else if leadingHole > 0 {
                let loc = BoardLayout.location(forHole: leadingHole)
                let rowFirstHole = BoardLayout.holeNumber(
                    section: loc.section,
                    column: loc.column,
                    row: loc.row,
                    position: 0
                )
                proxy.scrollTo(rowFirstHole, anchor: .center)
            }
        }
        if animated {
            withAnimation(.easeInOut(duration: 0.3)) { action() }
        } else {
            action()
        }
    }

    private var startArea: some View {
        HStack(spacing: 12) {
            Image(systemName: "flag.fill")
                .font(.title3)
                .foregroundStyle(BoardTheme.secondaryText)

            Text("START")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(BoardTheme.secondaryText)

            HStack(spacing: 8) {
                ForEach(0..<players.count, id: \.self) { idx in
                    Circle()
                        .fill(players[idx].frontPeg == 0 ? players[idx].color.color : Color.white.opacity(0.15))
                        .frame(width: 10, height: 10)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(BoardTheme.sectionBackground)
        )
    }

    private var winningHole: some View {
        VStack(spacing: 6) {
            Image(systemName: "trophy.circle.fill")
                .font(.system(size: 28))
                .foregroundStyle(.yellow)

            Text("FINISH")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(BoardTheme.primaryText)

            HStack(spacing: 8) {
                ForEach(0..<players.count, id: \.self) { idx in
                    Circle()
                        .fill(players[idx].frontPeg >= 121 ? players[idx].color.color : BoardTheme.emptyHole)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(players[idx].color.color.opacity(0.3), lineWidth: 2)
                        )
                }
            }

            Text("121")
                .font(.caption)
                .foregroundStyle(BoardTheme.secondaryText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(BoardTheme.sectionBackground)
                .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
        )
    }
}
