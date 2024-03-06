//
//  cupOfPositivityApp.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 2/17/24.
//

import SwiftUI

@main
struct cupOfPositivityApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
