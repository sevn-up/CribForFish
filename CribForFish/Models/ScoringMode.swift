import Foundation

enum ScoringMode: String, CaseIterable {
    case pegging = "Pegging"
    case counting = "Counting"

    var scores: [Int] {
        switch self {
        case .pegging:  [1, 2, 3, 4, 5, 6, 7, 8, 12]
        case .counting: [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 15, 16, 17, 20, 24, 29]
        }
    }
}
