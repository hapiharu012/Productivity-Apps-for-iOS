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
//  @StateObject var todoModel = TodoViewModel()
//  @StateObject var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        .environmentObject(todoModel)
        .onOpenURL { url in
          print("Received deep link: \(url)")
        }
    }
  }
}
