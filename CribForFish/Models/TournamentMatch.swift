import Foundation

struct TournamentMatch: Codable, Identifiable, Equatable {
    let id: String
    let round: Int
    let player1Name: String
    let player2Name: String
    let player1ColorIndex: Int
    let player2ColorIndex: Int
    var player1Score: Int?
    var player2Score: Int?
    var winnerName: String?
    var isComplete: Bool

    init(round: Int, player1Name: String, player2Name: String, player1ColorIndex: Int, player2ColorIndex: Int) {
        self.id = UUID().uuidString
        self.round = round
        self.player1Name = player1Name
        self.player2Name = player2Name
        self.player1ColorIndex = player1ColorIndex
        self.player2ColorIndex = player2ColorIndex
        self.isComplete = false
    }

    var isBye: Bool {
        player2Name == "BYE"
    }

    var displayName: String {
        if isBye {
            return "\(player1Name) (bye)"
        }
        return "\(player1Name) vs \(player2Name)"
    }
}
