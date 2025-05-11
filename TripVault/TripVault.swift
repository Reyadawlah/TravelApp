//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import SwiftUI

@main
struct TripVault: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
