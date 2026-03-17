import Foundation
import SwiftData
import SwiftUI

@Observable
final class GameEngine: GameEngineProtocol {
    var players: [PlayerState]
    var moves: [Move]
    var activePlayerIndex: Int
    var isGameOver: Bool
    var winnerIndex: Int?
    var playerCount: Int
    var dealerIndex: Int
    var tournamentMatchID: String?

    var persistence: GamePersistence?
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
        self.dealerIndex = 0
    }

    func load() {
        guard let persistence else { return }

        if let existing = persistence.loadLatestGame() {
            self.gameState = existing
            self.playerCount = existing.playerCount
            self.players = existing.players
            self.moves = existing.moves
            self.activePlayerIndex = existing.activePlayerIndex
            self.isGameOver = existing.isGameOver
            self.winnerIndex = players.firstIndex(where: { $0.hasWon })
            self.dealerIndex = existing.dealerIndex
        } else {
            let state = persistence.createGame(playerCount: playerCount)
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

        players[idx].backPeg = players[idx].frontPeg
        players[idx].frontPeg = min(players[idx].frontPeg + points, 121)

        if players[idx].hasWon {
            isGameOver = true
            winnerIndex = idx
            recordGameIfNeeded()
            HapticManager.winNotification()
        } else {
            // No auto-advance — active player stays until user explicitly switches
            if points == 29 {
                HapticManager.perfect29()
            } else {
                HapticManager.scoreImpact()
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
            gameState?.recorded = false
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
        dealerIndex = 0
        tournamentMatchID = nil
        gameState?.recorded = false
        save()
    }

    func newGame(profiles: [PlayerProfile]) {
        self.playerCount = profiles.count
        self.players = profiles.enumerated().map { idx, profile in
            PlayerState(name: profile.name, colorIndex: profile.colorIndex, frontPeg: 0, backPeg: 0)
        }
        moves = []
        activePlayerIndex = 0
        isGameOver = false
        winnerIndex = nil
        dealerIndex = 0
        tournamentMatchID = nil
        gameState?.recorded = false
        gameState?.playerProfileIDs = profiles.compactMap { $0.persistentModelID.hashValue.description }
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
        guard let gameState, let persistence else { return }
        persistence.save(gameState, players: players, moves: moves,
                        playerCount: playerCount, activePlayerIndex: activePlayerIndex,
                        isGameOver: isGameOver, dealerIndex: dealerIndex)
    }

    private func recordGameIfNeeded() {
        guard let winnerIndex, gameState?.recorded != true, let persistence else { return }
        _ = persistence.recordGame(players: players, moves: moves,
                                    winnerIndex: winnerIndex, tournamentID: tournamentMatchID)
        gameState?.recorded = true
    }
}
