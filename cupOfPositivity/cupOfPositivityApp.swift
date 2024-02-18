//
//  cupOfPositivityApp.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 2/17/24.
//

import SwiftUI

@main
struct cupOfPositivityApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
