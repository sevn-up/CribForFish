import Foundation
import SwiftData

@Model
final class PlayerProfile {
    var name: String
    var colorIndex: Int
    var createdAt: Date

    init(name: String, colorIndex: Int) {
        self.name = name
        self.colorIndex = colorIndex
        self.createdAt = Date()
    }

    var color: PlayerColor {
        PlayerColor(rawValue: colorIndex) ?? .red
    }
}
