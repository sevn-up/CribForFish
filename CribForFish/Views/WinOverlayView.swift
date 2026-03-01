import SwiftUI

struct WinOverlayView: View {
    let winnerName: String
    let winnerColor: Color
    let onNewGame: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "fish.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(winnerColor)

                Text("What a Catch!")
                    .font(.title3)
                    .foregroundStyle(OceanTheme.secondaryText)

                Text("\(winnerName) Wins!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("121 points")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))

                Button {
                    onNewGame()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Cast Again")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(winnerColor)
                    )
                }
                .padding(.top, 8)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(OceanTheme.sectionBackground.opacity(0.95))
            )
        }
        .transition(.opacity)
    }
}
