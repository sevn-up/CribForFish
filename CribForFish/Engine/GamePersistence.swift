import Foundation
import SwiftData

@MainActor
final class GamePersistence {
    private let modelContext: ModelContext

    init(context: ModelContext) {
        self.modelContext = context
    }

    func loadLatestGame() -> GameState? {
        let descriptor = FetchDescriptor<GameState>(
            sortBy: [SortDescriptor(\.lastModified, order: .reverse)]
        )
        return try? modelContext.fetch(descriptor).first
    }

    func createGame(playerCount: Int) -> GameState {
        let state = GameState(playerCount: playerCount)
        modelContext.insert(state)
        return state
    }

    func save(_ state: GameState, players: [PlayerState], moves: [Move],
              playerCount: Int, activePlayerIndex: Int, isGameOver: Bool, dealerIndex: Int) {
        state.playerCount = playerCount
        state.players = players
        state.moves = moves
        state.activePlayerIndex = activePlayerIndex
        state.isGameOver = isGameOver
        state.dealerIndex = dealerIndex
        state.lastModified = Date()
        try? modelContext.save()
    }

    func recordGame(players: [PlayerState], moves: [Move], winnerIndex: Int, tournamentID: String?) -> GameRecord {
        let record = GameRecord(players: players, moves: moves, winnerIndex: winnerIndex)
        record.tournamentID = tournamentID
        modelContext.insert(record)
        try? modelContext.save()
        return record
    }
}
