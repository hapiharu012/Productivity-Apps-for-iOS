//
//  Calendar+Extensions.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/18.
//

import SwiftUI


extension Calendar {
  func SameDayNum(todos: [Todo]) -> Int { // 今日のタスク数を返す
    let calendar = SwiftUI.Calendar.current
    var count = 0
    for todo in todos { // ForEachの代わりに通常のforループを使用
      if calendar.isDate(todo.deadline_date ?? Date(), inSameDayAs: Date()) && !todo.state {
        count += 1
      }
    }
    return count
  }
  
  func isSameDay(date1: Date, date2: Date) -> Bool { // 2つの日付が同じ日かどうかを返す
    let calendar = SwiftUI.Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
  }
  
  func formatDateTitleDayOfWeek(_ date: Date?) -> String { // 日付を「○曜日」の形式で返す
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "EE曜日"
    return formatter.string(from: date)
  }
  
  func formatDateTitleDay(_ date: Date?) -> String { // 日付を「○日」の形式で返す
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.dateFormat = "d日"
    return formatter.string(from: date)
  }
  
  func formatDate(_ date: Date?) -> String { // 日付を「○月○日」の形式で返す
      guard let date = date else { return "" }
      let calendar = Calendar.current
      let f = DateFormatter()
      f.locale = Locale(identifier: "ja_JP")
      
      if let diff = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date)).day {
          switch diff {
          case 0:
              return "今日"
          case 1:
              return "明日"
          case -1:
              return "昨日"
          case 2:
              return "明後日"
          case -2:
              return "一昨日"
          default:
              f.dateFormat = "M月d日"
              return f.string(from: date)
          }
      } else { // dateComponentsが何らかの理由でnilを返した場合
          f.dateFormat = "M月d日"
          return f.string(from: date)
      }
  }
  
}
