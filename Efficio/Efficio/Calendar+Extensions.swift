//
//  Calendar+Extensions.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/18.
//

import Foundation

extension Calendar {
  
  // MARK: - FORMAT DATE
  func formatDateAndOptimization(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日(E)"
    formatter.locale = Locale(identifier: "ja_JP")
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!
    if formatter.string(from: date) == formatter.string(from: today) {
      return "今日"
    } else if formatter.string(from: date) == formatter.string(from: tomorrow) {
      return "明日"
    } else if formatter.string(from: date) == formatter.string(from: dayAfterTomorrow) {
      return "明後日"
    } else {
      return formatter.string(from: date)
    }
  }
  
  // MARK: - FORMAT TIME
  func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "H時m分"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
  }
  
}
