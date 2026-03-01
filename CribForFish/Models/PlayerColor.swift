import SwiftUI

enum PlayerColor: Int, Codable, CaseIterable {
    case coral = 0
    case ocean = 1
    case kelp = 2

    var color: Color {
        switch self {
        case .coral: Color(red: 1.0, green: 0.45, blue: 0.40)
        case .ocean: Color(red: 0.25, green: 0.55, blue: 1.0)
        case .kelp: Color(red: 0.20, green: 0.80, blue: 0.65)
        }
    }

    var name: String {
        switch self {
        case .coral: "Coral"
        case .ocean: "Ocean"
        case .kelp: "Kelp"
        }
    }
}
