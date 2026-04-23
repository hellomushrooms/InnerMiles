//
//  InnerMilesApp.swift
//  InnerMiles
//
//  Created by Disha Kurkuri on 23/04/26.
//

import SwiftUI
import CoreData

@main
struct InnerMilesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
