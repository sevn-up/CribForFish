//
//  ContentView.swift
//  CribForFish
//
//  Created by Sev Nielsen on 2026-02-28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var engine = GameEngine()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            GameView(engine: engine)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller.fill")
                }
                .tag(0)

            StatsTabView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(1)

            TournamentListView()
                .tabItem {
                    Label("Tournaments", systemImage: "trophy.fill")
                }
                .tag(2)
        }
        .tint(.white)
        .preferredColorScheme(.dark)
        .onAppear {
            engine.persistence = GamePersistence(context: modelContext)
            engine.load()
            styleTabBar()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                engine.save()
            }
        }
    }

    private func styleTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(BoardTheme.headerBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [GameState.self, PlayerProfile.self, GameRecord.self, Tournament.self], inMemory: true)
}
