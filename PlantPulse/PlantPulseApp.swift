//
//  PlantPulseApp.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/16/24.
//

import SwiftUI

@main
struct PlantPulseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
