//
//  CameraBagApp.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//

import SwiftUI

@main
struct CameraBagApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
