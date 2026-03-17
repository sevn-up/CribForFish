import SwiftUI
import SwiftData

struct PlayerSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PlayerProfile.createdAt) private var profiles: [PlayerProfile]

    @Binding var playerCount: Int
    @Binding var selectedProfiles: [PlayerProfile]
    let onStart: () -> Void
    let onCancel: () -> Void

    @State private var editingNames: [String] = ["", "", ""]
    @State private var editingColors: [Int] = [0, 1, 2]
    @State private var showConfirmReset = false

    var body: some View {
        VStack(spacing: 20) {
            Text("New Game")
                .font(.headline)
                .foregroundStyle(.white)

            Picker("Players", selection: $playerCount) {
                Text("2 Players").tag(2)
                Text("3 Players").tag(3)
            }
            .pickerStyle(.segmented)
            .onChange(of: playerCount) {
                syncFromProfiles()
            }

            VStack(spacing: 12) {
                ForEach(0..<playerCount, id: \.self) { idx in
                    HStack(spacing: 12) {
                        TextField("Player \(idx + 1)", text: $editingNames[idx])
                            .textFieldStyle(.plain)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.white)

                        HStack(spacing: 6) {
                            ForEach(PlayerColor.allCases, id: \.rawValue) { pc in
                                Circle()
                                    .fill(pc.color)
                                    .frame(width: 28, height: 28)
                                    .overlay {
                                        if editingColors[idx] == pc.rawValue {
                                            Circle().stroke(.white, lineWidth: 2)
                                        }
                                    }
                                    .onTapGesture {
                                        editingColors[idx] = pc.rawValue
                                    }
                            }
                        }
                    }
                }
            }

            HStack(spacing: 16) {
                Button {
                    onCancel()
                } label: {
                    Text("Cancel")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.1))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button {
                    applyAndStart()
                } label: {
                    Text("Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(BoardTheme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(24)
        .onAppear {
            seedDefaultProfilesIfNeeded()
            syncFromProfiles()
        }
    }

    private func seedDefaultProfilesIfNeeded() {
        guard profiles.isEmpty else { return }
        let defaults: [(String, Int)] = [("Marlin", 0), ("Tuna", 1), ("Salmon", 2)]
        for (name, color) in defaults {
            modelContext.insert(PlayerProfile(name: name, colorIndex: color))
        }
        try? modelContext.save()
    }

    private func syncFromProfiles() {
        let names = ["Marlin", "Tuna", "Salmon"]
        for i in 0..<3 {
            if i < profiles.count {
                editingNames[i] = profiles[i].name
                editingColors[i] = profiles[i].colorIndex
            } else {
                editingNames[i] = names[i]
                editingColors[i] = i
            }
        }
    }

    private func applyAndStart() {
        var result: [PlayerProfile] = []
        for i in 0..<playerCount {
            let name = editingNames[i].trimmingCharacters(in: .whitespaces)
            let finalName = name.isEmpty ? "Player \(i + 1)" : name

            if i < profiles.count {
                profiles[i].name = finalName
                profiles[i].colorIndex = editingColors[i]
                result.append(profiles[i])
            } else {
                let profile = PlayerProfile(name: finalName, colorIndex: editingColors[i])
                modelContext.insert(profile)
                result.append(profile)
            }
        }
        try? modelContext.save()
        selectedProfiles = result
        onStart()
    }
}
