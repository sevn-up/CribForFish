import Foundation
import SwiftData
import SwiftUI

@Observable
final class GameEngine {
    var players: [PlayerState]
    var moves: [Move]
    var activePlayerIndex: Int
    var isGameOver: Bool
    var winnerIndex: Int?
    var playerCount: Int

    private var modelContext: ModelContext?
    private var gameState: GameState?

    static func defaultPlayers(count: Int) -> [PlayerState] {
        let names = ["Marlin", "Tuna", "Salmon"]
        return (0..<count).map { i in
            PlayerState(name: names[i], colorIndex: i, frontPeg: 0, backPeg: 0)
        }
    }

    init() {
        self.playerCount = 3
        self.players = GameEngine.defaultPlayers(count: 3)
        self.moves = []
        self.activePlayerIndex = 0
        self.isGameOver = false
    }

    func load(context: ModelContext) {
        self.modelContext = context

        let descriptor = FetchDescriptor<GameState>(
            sortBy: [SortDescriptor(\.lastModified, order: .reverse)]
        )

        if let existing = try? context.fetch(descriptor).first {
            self.gameState = existing
            self.playerCount = existing.playerCount
            self.players = existing.players
            self.moves = existing.moves
            self.activePlayerIndex = existing.activePlayerIndex
            self.isGameOver = existing.isGameOver
            self.winnerIndex = players.firstIndex(where: { $0.hasWon })
        } else {
            let state = GameState(playerCount: playerCount)
            context.insert(state)
            self.gameState = state
            save()
        }
    }

    func addScore(_ points: Int, forPlayer playerIndex: Int? = nil) {
        guard !isGameOver else { return }
        let idx = playerIndex ?? activePlayerIndex
        guard idx >= 0 && idx < players.count else { return }

        let move = Move(
            playerIndex: idx,
            points: points,
            previousFrontPeg: players[idx].frontPeg,
            previousBackPeg: players[idx].backPeg
        )
        moves.append(move)

        // Back peg moves to where front peg was
        players[idx].backPeg = players[idx].frontPeg
        // Front peg advances, capped at 121
        players[idx].frontPeg = min(players[idx].frontPeg + points, 121)

        if players[idx].hasWon {
            isGameOver = true
            winnerIndex = idx
            triggerHaptic(.notification(.init(rawValue: 0)!))
        } else {
            // Auto-advance to next player
            activePlayerIndex = (idx + 1) % players.count
            if points == 29 {
                triggerHaptic(.notification(.init(rawValue: 0)!))
            } else {
                triggerHaptic(.impact(.init(rawValue: 1)!))
            }
        }

        save()
    }

    func undo() {
        guard let lastMove = moves.popLast() else { return }

        let idx = lastMove.playerIndex
        players[idx].frontPeg = lastMove.previousFrontPeg
        players[idx].backPeg = lastMove.previousBackPeg

        if isGameOver {
            isGameOver = false
            winnerIndex = nil
        }

        activePlayerIndex = idx
        save()
    }

    func newGame(playerCount: Int? = nil) {
        if let count = playerCount {
            self.playerCount = count
        }
        players = GameEngine.defaultPlayers(count: self.playerCount)
        moves = []
        activePlayerIndex = 0
        isGameOver = false
        winnerIndex = nil
        save()
    }

    func selectPlayer(_ index: Int) {
        guard index >= 0 && index < players.count else { return }
        activePlayerIndex = index
    }

    var leadingHole: Int {
        players.map(\.frontPeg).max() ?? 0
    }

    func save() {
        gameState?.playerCount = playerCount
        gameState?.players = players
        gameState?.moves = moves
        gameState?.activePlayerIndex = activePlayerIndex
        gameState?.isGameOver = isGameOver
        gameState?.lastModified = Date()
        try? modelContext?.save()
    }

    private func triggerHaptic(_ type: HapticType) {
        #if os(iOS)
        switch type {
        case .impact(let style):
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        case .notification(let notifType):
            UINotificationFeedbackGenerator().notificationOccurred(notifType)
        }
        #endif
    }

    private enum HapticType {
        case impact(UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
    }
}
