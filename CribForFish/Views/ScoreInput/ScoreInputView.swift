import SwiftUI

struct ScoreInputView: View {
    @Bindable var engine: GameEngine
    @State private var showNewGameSheet = false
    @State private var pendingPlayerCount: Int = 3
    @State private var scoringMode: ScoringMode = .counting

    var body: some View {
        VStack(spacing: 12) {
            PlayerSelectorView(
                players: engine.players,
                activeIndex: engine.activePlayerIndex,
                onSelect: { engine.selectPlayer($0) }
            )

            Picker("Mode", selection: $scoringMode) {
                ForEach(ScoringMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            QuickScoreGrid(
                scores: scoringMode.scores,
                activeColor: engine.players[engine.activePlayerIndex].color.color
            ) { points in
                engine.addScore(points)
            }

            HStack(spacing: 16) {
                Button {
                    engine.undo()
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .font(.subheadline)
                        .foregroundStyle(OceanTheme.secondaryText)
                }
                .disabled(engine.moves.isEmpty)

                Spacer()

                Button {
                    pendingPlayerCount = engine.playerCount
                    showNewGameSheet = true
                } label: {
                    Label("New Game", systemImage: "arrow.counterclockwise")
                        .font(.subheadline)
                        .foregroundStyle(PlayerColor.coral.color)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(OceanTheme.inputBackground)
        .sheet(isPresented: $showNewGameSheet) {
            VStack(spacing: 24) {
                Text("New Game")
                    .font(.headline)
                    .foregroundStyle(.white)

                Picker("Players", selection: $pendingPlayerCount) {
                    Text("2 Players").tag(2)
                    Text("3 Players").tag(3)
                }
                .pickerStyle(.segmented)

                Text("This will reset all scores.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                HStack(spacing: 16) {
                    Button {
                        showNewGameSheet = false
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button {
                        engine.newGame(playerCount: pendingPlayerCount)
                        showNewGameSheet = false
                    } label: {
                        Text("Start")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(PlayerColor.coral.color)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(24)
            .presentationDetents([.height(240)])
            .presentationBackground(OceanTheme.inputBackground)
        }
    }
}
