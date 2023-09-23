//
//  EfficioApp.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/24.
//

import SwiftUI

@main
struct EfficioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
