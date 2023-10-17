//
//  EfficioApp.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/09/24.
//

import SwiftUI

@main
struct EfficioApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .onOpenURL { url in
          print("Received deep link: \(url)")
        }
    }
  }
}
