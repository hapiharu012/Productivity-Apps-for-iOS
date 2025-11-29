//
//  CommonViewFunctions.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import CoreData

// MARK: - SORT ENUMS
enum SortCriteria: String {
  case priority = "優先度"
  case deadline = "期日"
}

enum SortOrder: String {
  case ascending = "昇順"
  case descending = "降順"
}

struct Utility {
  static func determiningPriority (priority: Int16) -> Bool {
    switch priority {
    case 3: // 高
      return true
    default:
      return false
    }
  }
  static func colorize(priority: Int16) -> Color {
    switch priority {
    case 3: // 高
      return .pink
    case 2: // 中
      return .green
    case 1: // 低
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
        todo.priority = Int16(i) - 1
        todo.id = UUID()  // このid属性が必要です。
        // 他の属性もここで設定できます
        return todo
    }
  }

  // MARK: - FILTER AND SORT TODOS (for Widget)
  /// アプリの設定に基づいてTodoをフィルタリング・ソートする
  /// ウィジェットでは常に未完了タスクのみを表示（表示スペースが限られているため）
  static func filterAndSortTodos(_ todos: [Todo]) -> [Todo] {
    var filtered = todos

    // App GroupのUserDefaultsから設定を取得
    guard let sharedDefaults = UserDefaults(suiteName: "group.hapiharu012.Efficio.app") else {
      return todos
    }

    let sortBy: SortCriteria = {
      if let savedValue = sharedDefaults.string(forKey: "FilterSortBy"),
         let criteria = SortCriteria(rawValue: savedValue) {
        return criteria
      }
      return .priority
    }()

    let sortOrder: SortOrder = {
      if let savedValue = sharedDefaults.string(forKey: "FilterSortOrder"),
         let order = SortOrder(rawValue: savedValue) {
        return order
      }
      return .ascending
    }()

    // ウィジェットでは常に完了済みタスクを非表示
    filtered = filtered.filter { !$0.state }

    // ソート処理
    filtered = sortTodos(filtered, by: sortBy, order: sortOrder)

    return filtered
  }

  // MARK: - SORT TODOS
  private static func sortTodos(_ todos: [Todo], by sortBy: SortCriteria, order sortOrder: SortOrder) -> [Todo] {
    switch sortBy {
    case .priority:
      // 優先度でソート（優先度0=未設定は常に最後）
      return todos.sorted { todo1, todo2 in
        let p1 = todo1.priority
        let p2 = todo2.priority

        // 優先度0（未設定）の扱い
        if p1 == 0 && p2 == 0 {
          return todo1.order < todo2.order // 両方未設定の場合はorder順
        } else if p1 == 0 {
          return false // todo1が未設定の場合は後ろ
        } else if p2 == 0 {
          return true // todo2が未設定の場合はtodo1が前
        }

        if sortOrder == .ascending {
          return p1 > p2  // 高い順（3, 2, 1）
        } else {
          return p1 < p2  // 低い順（1, 2, 3）
        }
      }

    case .deadline:
      // 期日でソート（deadline_dateがnilのものは最後）
      return todos.sorted { todo1, todo2 in
        let date1 = todo1.deadline_date
        let date2 = todo2.deadline_date

        if date1 == nil && date2 == nil {
          return todo1.order < todo2.order // 両方nilの場合はorder順
        } else if date1 == nil {
          return false // todo1がnilの場合は後ろ
        } else if date2 == nil {
          return true // todo2がnilの場合はtodo1が前
        } else {
          if sortOrder == .ascending {
            return date1! < date2!
          } else {
            return date1! > date2!
          }
        }
      }
    }
  }
}
  

