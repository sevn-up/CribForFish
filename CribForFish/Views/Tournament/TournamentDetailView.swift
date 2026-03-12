import SwiftUI
import SwiftData

struct TournamentDetailView: View {
    @Bindable var tournament: Tournament
    @Environment(\.modelContext) private var modelContext
    @State private var playingMatchID: String?
    @State private var showGame = false

    var body: some View {
        List {
            Section("Standings") {
                LeaderboardView(standings: tournament.standings)
            }

            ForEach(Array(tournament.rounds.enumerated()), id: \.offset) { roundIdx, roundMatches in
                Section("Round \(roundIdx + 1)") {
                    ForEach(roundMatches) { match in
                        matchRow(match)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(BoardTheme.headerBackground)
        .navigationTitle(tournament.name)
        .sheet(isPresented: $showGame) {
            if let matchID = playingMatchID {
                TournamentGameSheet(
                    tournament: tournament,
                    matchID: matchID,
                    onComplete: { p1Score, p2Score, winnerName in
                        updateMatch(matchID: matchID, p1Score: p1Score, p2Score: p2Score, winnerName: winnerName)
                        showGame = false
                    },
                    onCancel: {
                        showGame = false
                    }
                )
            }
        }
    }

    private func matchRow(_ match: TournamentMatch) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                if match.isBye {
                    Text("\(match.player1Name) \u{2014} bye")
                        .font(.subheadline)
                        .foregroundStyle(BoardTheme.secondaryText)
                } else {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(PlayerColor(rawValue: match.player1ColorIndex)?.color ?? .white)
                            .frame(width: 8, height: 8)
                        Text(match.player1Name)
                            .foregroundStyle(match.winnerName == match.player1Name ? .white : BoardTheme.secondaryText)
                            .fontWeight(match.winnerName == match.player1Name ? .bold : .regular)

                        Text("vs")
                            .foregroundStyle(BoardTheme.secondaryText)
                            .font(.caption)

                        Circle()
                            .fill(PlayerColor(rawValue: match.player2ColorIndex)?.color ?? .white)
                            .frame(width: 8, height: 8)
                        Text(match.player2Name)
                            .foregroundStyle(match.winnerName == match.player2Name ? .white : BoardTheme.secondaryText)
                            .fontWeight(match.winnerName == match.player2Name ? .bold : .regular)
                    }
                    .font(.subheadline)

                    if match.isComplete, let p1 = match.player1Score, let p2 = match.player2Score {
                        Text("\(p1) - \(p2)")
                            .font(.caption)
                            .foregroundStyle(BoardTheme.secondaryText)
                    }
                }
            }

            Spacer()

            if !match.isBye && !match.isComplete {
                Button("Play") {
                    playingMatchID = match.id
                    showGame = true
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(BoardTheme.accent))
            } else if match.isComplete && !match.isBye {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .listRowBackground(BoardTheme.sectionBackground)
    }

    private func updateMatch(matchID: String, p1Score: Int, p2Score: Int, winnerName: String) {
        var allMatches = tournament.matches
        if let idx = allMatches.firstIndex(where: { $0.id == matchID }) {
            allMatches[idx].player1Score = p1Score
            allMatches[idx].player2Score = p2Score
            allMatches[idx].winnerName = winnerName
            allMatches[idx].isComplete = true
        }
        tournament.matches = allMatches
        tournament.checkCompletion()
        try? modelContext.save()
    }
}

struct TournamentGameSheet: View {
    let tournament: Tournament
    let matchID: String
    let onComplete: (Int, Int, String) -> Void
    let onCancel: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var engine = GameEngine()
    @State private var hasLoaded = false

    private var match: TournamentMatch? {
        tournament.matches.first { $0.id == matchID }
    }

    var body: some View {
        Group {
            if let match {
                ZStack {
                    GameView(engine: engine)

                    if engine.isGameOver {
                        Color.clear.onAppear {
                            let p1Score: Int
                            let p2Score: Int
                            if engine.players.count >= 2 {
                                p1Score = engine.players[0].frontPeg
                                p2Score = engine.players[1].frontPeg
                            } else {
                                p1Score = 0
                                p2Score = 0
                            }
                            let winner = engine.winnerIndex == 0 ? match.player1Name : match.player2Name
                            onComplete(p1Score, p2Score, winner)
                        }
                    }
                }
                .onAppear {
                    if !hasLoaded {
                        engine.persistence = GamePersistence(context: modelContext)
                        engine.load()
                        let players = [
                            PlayerState(name: match.player1Name, colorIndex: match.player1ColorIndex, frontPeg: 0, backPeg: 0),
                            PlayerState(name: match.player2Name, colorIndex: match.player2ColorIndex, frontPeg: 0, backPeg: 0)
                        ]
                        engine.playerCount = 2
                        engine.players = players
                        engine.moves = []
                        engine.activePlayerIndex = 0
                        engine.isGameOver = false
                        engine.winnerIndex = nil
                        engine.tournamentMatchID = matchID
                        hasLoaded = true
                    }
                }
            }
        }
        .overlay(alignment: .topLeading) {
            Button {
                onCancel()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(BoardTheme.secondaryText)
                    .padding()
            }
        }
    }
}
