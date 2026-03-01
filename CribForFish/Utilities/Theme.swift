import SwiftUI

enum OceanTheme {
    static let boardGradient = LinearGradient(
        colors: [Color(red: 0.05, green: 0.15, blue: 0.35), Color(red: 0.02, green: 0.08, blue: 0.25)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let sectionBackground = Color(red: 0.08, green: 0.18, blue: 0.38)
    static let inputBackground = Color(red: 0.04, green: 0.10, blue: 0.28)
    static let headerBackground = Color(red: 0.03, green: 0.07, blue: 0.22)
    static let emptyHole = Color.white.opacity(0.15)
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.6)
}
