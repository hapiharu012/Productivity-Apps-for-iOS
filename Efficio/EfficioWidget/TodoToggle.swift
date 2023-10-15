//
//  TodoToggle.swift
//  EfficioWidgetExtension
//
//  Created by k21123kk on 2023/10/10.
//


import SwiftUI
import AppIntents
//import CoreData

struct TodoToggleIntent: AppIntent {
  @Environment(\.managedObjectContext) private var managedObjectContext

  @ObservedObject private var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  
    static var title: LocalizedStringResource = "Toggle Task State"
  
    
    /// Parameters
    @Parameter(title: "Task ID")
    var todo: String
    
    init() {
        
    }
    
    init(todo: String) {
        self.todo = todo
    }
    
    func perform() async throws -> some IntentResult {
      todoModel.toggleTodoStateById(forTask: todo)
//      TodoViewModel(context: PersistenceController.shared.container.viewContext).toggleState(forTask: todo)

      return .result()
    }
  
  
}
