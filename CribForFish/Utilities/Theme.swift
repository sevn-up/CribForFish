import SwiftUI

enum BoardTheme {
    static let boardGradient = LinearGradient(
        colors: [Color(red: 0.28, green: 0.18, blue: 0.10), Color(red: 0.20, green: 0.12, blue: 0.06)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let sectionBackground = Color(red: 0.35, green: 0.24, blue: 0.14)
    static let inputBackground = Color(red: 0.22, green: 0.14, blue: 0.08)
    static let headerBackground = Color(red: 0.18, green: 0.11, blue: 0.06)
    static let emptyHole = Color(red: 0.55, green: 0.45, blue: 0.35).opacity(0.4)
    static let primaryText = Color(red: 0.95, green: 0.90, blue: 0.82)
    static let secondaryText = Color(red: 0.75, green: 0.65, blue: 0.52)
    static let accent = Color(red: 0.85, green: 0.65, blue: 0.30)
}
