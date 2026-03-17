import SwiftUI
import SwiftData

struct TournamentSetupView: View {
    @Query(sort: \PlayerProfile.createdAt) private var profiles: [PlayerProfile]

    @State private var name = ""
    @State private var playerNames: [String] = ["", "", ""]
    @State private var playerColors: [Int] = [0, 1, 2]
    @State private var playerCount = 3

    let onCreate: (Tournament) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("New Tournament")
                .font(.headline)
                .foregroundStyle(.white)

            TextField("Tournament Name", text: $name)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(.white)

            HStack {
                ForEach(3...6, id: \.self) { count in
                    Button {
                        playerCount = count
                        ensureSlots()
                    } label: {
                        Text("\(count)")
                            .font(.subheadline)
                            .fontWeight(playerCount == count ? .bold : .regular)
                            .foregroundStyle(playerCount == count ? .white : BoardTheme.secondaryText)
                            .frame(width: 44, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(playerCount == count ? BoardTheme.accent : Color.white.opacity(0.1))
                            )
                    }
                }
                Text("players")
                    .font(.caption)
                    .foregroundStyle(BoardTheme.secondaryText)
            }

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<playerCount, id: \.self) { idx in
                        HStack(spacing: 8) {
                            TextField("Player \(idx + 1)", text: $playerNames[idx])
                                .textFieldStyle(.plain)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)

                            HStack(spacing: 4) {
                                ForEach(PlayerColor.allCases, id: \.rawValue) { pc in
                                    Circle()
                                        .fill(pc.color)
                                        .frame(width: 24, height: 24)
                                        .overlay {
                                            if playerColors[idx] == pc.rawValue {
                                                Circle().stroke(.white, lineWidth: 2)
                                            }
                                        }
                                        .onTapGesture {
                                            playerColors[idx] = pc.rawValue
                                        }
                                }
                            }
                        }
                    }
                }
            }

            Button {
                createTournament()
            } label: {
                Text("Create Tournament")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(BoardTheme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(!isValid)
        }
        .padding(24)
        .onAppear {
            loadFromProfiles()
        }
    }

    private var isValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty && finalNames.count == playerCount
    }

    private var finalNames: [String] {
        (0..<playerCount).map { idx in
            let n = playerNames[idx].trimmingCharacters(in: .whitespaces)
            return n.isEmpty ? "Player \(idx + 1)" : n
        }
    }

    private func ensureSlots() {
        while playerNames.count < playerCount {
            playerNames.append("")
            playerColors.append(playerColors.count % PlayerColor.allCases.count)
        }
    }

    private func loadFromProfiles() {
        for (i, profile) in profiles.prefix(6).enumerated() {
            if i < playerNames.count {
                playerNames[i] = profile.name
                playerColors[i] = profile.colorIndex
            }
        }
    }

    private func createTournament() {
        let names = finalNames
        let colors = Array(playerColors.prefix(playerCount))
        let matches = TournamentScheduler.generateSchedule(
            playerNames: names,
            playerColorIndices: colors
        )
        let tournament = Tournament(
            name: name.trimmingCharacters(in: .whitespaces),
            playerNames: names,
            playerColorIndices: colors,
            matches: matches
        )
        onCreate(tournament)
    }
}
