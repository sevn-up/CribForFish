import SwiftUI

struct QuickScoreGrid: View {
    let scores: [Int]
    let activeColor: Color
    let onScore: (Int) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

    var body: some View {
        VStack(spacing: 8) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(regularScores, id: \.self) { value in
                    scoreButton(value: value)
                }
            }

            if scores.contains(29) {
                perfect29Button
            }
        }
    }

    private var regularScores: [Int] {
        scores.filter { $0 != 29 }
    }

    private func scoreButton(value: Int) -> some View {
        Button {
            onScore(value)
        } label: {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(activeColor.opacity(0.15))
                .foregroundStyle(activeColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var perfect29Button: some View {
        Button {
            onScore(29)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "fish.fill")
                    .font(.body)
                Text("Perfect 29")
                    .font(.title3)
                    .fontWeight(.bold)
                Image(systemName: "fish.fill")
                    .font(.body)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                LinearGradient(
                    colors: [Color.yellow.opacity(0.25), Color.orange.opacity(0.25)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.yellow.opacity(0.5), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
