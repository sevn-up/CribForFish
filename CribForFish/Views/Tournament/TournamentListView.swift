import SwiftUI
import SwiftData

struct TournamentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tournament.createdAt, order: .reverse) private var tournaments: [Tournament]
    @State private var showSetup = false

    var body: some View {
        NavigationStack {
            List {
                if tournaments.isEmpty {
                    ContentUnavailableView(
                        "No Tournaments",
                        systemImage: "trophy",
                        description: Text("Create a tournament to compete with friends!")
                    )
                } else {
                    let active = tournaments.filter { !$0.isComplete }
                    let completed = tournaments.filter { $0.isComplete }

                    if !active.isEmpty {
                        Section("Active") {
                            ForEach(active) { tournament in
                                NavigationLink {
                                    TournamentDetailView(tournament: tournament)
                                } label: {
                                    tournamentRow(tournament)
                                }
                            }
                            .onDelete { offsets in
                                for idx in offsets {
                                    modelContext.delete(active[idx])
                                }
                            }
                        }
                    }

                    if !completed.isEmpty {
                        Section("Completed") {
                            ForEach(completed) { tournament in
                                NavigationLink {
                                    TournamentDetailView(tournament: tournament)
                                } label: {
                                    tournamentRow(tournament)
                                }
                            }
                            .onDelete { offsets in
                                for idx in offsets {
                                    modelContext.delete(completed[idx])
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BoardTheme.headerBackground)
            .navigationTitle("Tournaments")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSetup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showSetup) {
                TournamentSetupView { tournament in
                    modelContext.insert(tournament)
                    try? modelContext.save()
                    showSetup = false
                }
                .presentationDetents([.medium])
                .presentationBackground(BoardTheme.inputBackground)
            }
        }
    }

    private func tournamentRow(_ tournament: Tournament) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(tournament.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                if tournament.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            HStack(spacing: 8) {
                Text("\(tournament.playerNames.count) players")
                let playable = tournament.matches.filter { !$0.isBye }
                let completed = playable.filter(\.isComplete).count
                Text("\(completed)/\(playable.count) matches")
            }
            .font(.caption)
            .foregroundStyle(BoardTheme.secondaryText)
        }
        .padding(.vertical, 2)
        .listRowBackground(BoardTheme.sectionBackground)
    }
}
