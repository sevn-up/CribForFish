import SwiftUI

struct CompactScoreInputBar: View {
    var engine: any GameEngineProtocol
    @Binding var showWinOverlay: Bool
    @State private var showMoreScores = false
    @State private var showNewGameSheet = false
    @State private var pendingPlayerCount: Int = 3
    @State private var selectedProfiles: [PlayerProfile] = []
    @State private var showConfirmation = false

    private let quickScores = [1, 2, 3, 4, 5, 6]

    var body: some View {
        Group {
            if engine.isGameOver {
                gameOverBar
            } else {
                scoringBar
            }
        }
        .frame(height: 56)
        .background(BoardTheme.inputBackground)
        .sheet(isPresented: $showMoreScores) {
            VStack(spacing: 16) {
                Text("Score")
                    .font(.headline)
                    .foregroundStyle(BoardTheme.primaryText)

                QuickScoreGrid(
                    activeColor: engine.players[engine.activePlayerIndex].color.color
                ) { points in
                    engine.addScore(points, forPlayer: nil)
                    showMoreScores = false
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 20)
            .presentationDetents([.medium])
            .presentationBackground(BoardTheme.inputBackground)
        }
        .alert("Game in Progress", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("New Game", role: .destructive) {
                showNewGameSheet = true
            }
        } message: {
            Text("Starting a new game will reset all current scores. Are you sure?")
        }
        .sheet(isPresented: $showNewGameSheet) {
            PlayerSetupView(
                playerCount: $pendingPlayerCount,
                selectedProfiles: $selectedProfiles,
                onStart: {
                    if selectedProfiles.isEmpty {
                        engine.newGame(playerCount: pendingPlayerCount)
                    } else {
                        engine.newGame(profiles: selectedProfiles)
                    }
                    showNewGameSheet = false
                },
                onCancel: {
                    showNewGameSheet = false
                }
            )
            .presentationDetents([.height(320)])
            .presentationBackground(BoardTheme.inputBackground)
        }
    }

    private var gameOverBar: some View {
        HStack(spacing: 16) {
            Button {
                showWinOverlay = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                    Text("Results")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(BoardTheme.accent)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(BoardTheme.accent.opacity(0.15))
                )
            }

            Button {
                pendingPlayerCount = engine.playerCount
                showNewGameSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("New Game")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(BoardTheme.accent)
                )
            }
        }
        .padding(.horizontal, 12)
    }

    private var scoringBar: some View {
        HStack(spacing: 8) {
            // Undo button
            Button {
                engine.undo()
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .font(.body)
                    .foregroundStyle(BoardTheme.secondaryText)
                    .frame(width: 36, height: 36)
            }
            .disabled(engine.moves.isEmpty)

            // Quick score buttons
            HStack(spacing: 6) {
                ForEach(quickScores, id: \.self) { value in
                    Button {
                        engine.addScore(value, forPlayer: nil)
                    } label: {
                        Text("\(value)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(engine.players[engine.activePlayerIndex].color.color.opacity(0.2))
                            .foregroundStyle(engine.players[engine.activePlayerIndex].color.color)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    showMoreScores = true
                } label: {
                    Image(systemName: "plus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(BoardTheme.accent.opacity(0.2))
                        .foregroundStyle(BoardTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }

            // New game button
            Button {
                pendingPlayerCount = engine.playerCount
                if engine.moves.isEmpty {
                    showNewGameSheet = true
                } else {
                    showConfirmation = true
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.body)
                    .foregroundStyle(BoardTheme.accent)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 12)
    }
}
