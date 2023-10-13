//
//  CommonViewFunctions.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import CoreData


  
  func isSameDay(date1: Date, date2: Date) -> Bool {
    let calendar = SwiftUI.Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
  }
  func SameDayNum(todos: [Todo]) -> Int {
    let calendar = SwiftUI.Calendar.current
    var count = 0
    for todo in todos { // ForEachの代わりに通常のforループを使用
      if calendar.isDate(todo.deadline ?? Date(), inSameDayAs: Date()) {
        count += 1
      }
    }
    return count
  }
  func formatDateTitleDayOfWeek(_ date: Date?) -> String {
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "EE曜日"
    return formatter.string(from: date)
  }
  func formatDateTitleDay(_ date: Date?) -> String {
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    
    formatter.dateFormat = "d日"
    return formatter.string(from: date)
  }
  func formatDate(_ date: Date?) -> String {
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日"
    return formatter.string(from: date)
  }
  func determiningPriority (priority: String) -> Bool {
    switch priority {
    case "高":
      return true
    default:
      return false
    }
  }
  func colorize(priority: String) -> Color {
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

func createDummyTodos(context: NSManagedObjectContext) -> [Todo] {
    (1...4).map { i in
        let todo = Todo(context: context)
        todo.name = "タスク \(i)"
        todo.state = false
        todo.deadline = Date()
        todo.priority = "中"
        todo.id = UUID()  // このid属性が必要です。
        // 他の属性もここで設定できます
        return todo
    }
}


extension View {
  func widgetBackground(_ backgroundView: some View) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      return containerBackground(for: .widget) {
        backgroundView
      }
    } else {
      return background(backgroundView)
    }
  }
  
}
