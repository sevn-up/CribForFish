//
//  CribForFishApp.swift
//  CribForFish
//
//  Created by Sev Nielsen on 2026-02-28.
//

import SwiftUI
import SwiftData

@main
struct CribForFishApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameState.self,
            PlayerProfile.self,
            GameRecord.self,
            Tournament.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
