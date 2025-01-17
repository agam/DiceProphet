//
//  Dice_ProphetApp.swift
//  Dice Prophet
//
//  Created by Agam Brahma on 9/29/24.
//

import SwiftUI
import SwiftData

@main
struct Dice_ProphetApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Guess.self,
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
