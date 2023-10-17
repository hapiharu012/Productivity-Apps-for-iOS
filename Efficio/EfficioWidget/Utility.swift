//
//  CommonViewFunctions.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import CoreData



struct Utility {
  static func determiningPriority (priority: String) -> Bool {
    switch priority {
    case "高":
      return true
    default:
      return false
    }
  }
  static func colorize(priority: String) -> Color {
    switch priority {
    case "高":
      return .pink
    case "中":
      return .green
    case "低":
      return .blue
    default:
      return .clear
    }
  }

  static func createDummyTodos(context: NSManagedObjectContext) -> [Todo] {
    (1...4).map { i in
        let todo = Todo(context: context)
        todo.name = "タスク \(i)"
        todo.state = false
        todo.deadline_date = Date()
        todo.priority = "中"
        todo.id = UUID()  // このid属性が必要です。
        // 他の属性もここで設定できます
        return todo
    }
}
}
  

