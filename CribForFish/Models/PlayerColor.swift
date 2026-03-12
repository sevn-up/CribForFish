import SwiftUI

enum PlayerColor: Int, Codable, CaseIterable {
    case red = 0
    case blue = 1
    case green = 2

    var color: Color {
        switch self {
        case .red: Color(red: 0.90, green: 0.25, blue: 0.20)
        case .blue: Color(red: 0.30, green: 0.60, blue: 1.0)
        case .green: Color(red: 0.25, green: 0.85, blue: 0.40)
        }
    }

    var name: String {
        switch self {
        case .red: "Red"
        case .blue: "Blue"
        case .green: "Green"
        }
    }
}
