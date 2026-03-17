import Foundation

@MainActor
protocol GameEngineProtocol: Observable {
    var players: [PlayerState] { get }
    var moves: [Move] { get }
    var activePlayerIndex: Int { get }
    var isGameOver: Bool { get }
    var winnerIndex: Int? { get }
    var playerCount: Int { get }
    var dealerIndex: Int { get }
    var leadingHole: Int { get }

    func addScore(_ points: Int, forPlayer playerIndex: Int?)
    func undo()
    func selectPlayer(_ index: Int)
    func newGame(playerCount: Int?)
    func newGame(profiles: [PlayerProfile])
    func save()
}
