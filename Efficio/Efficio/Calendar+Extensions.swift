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
            f.dateFormat = "M月d日(E)"
            return f.string(from: date)
        }
    } else { // dateComponentsが何らかの理由でnilを返した場合
        f.dateFormat = "M月d日(E)"
        return f.string(from: date)
    }
  }
  
  // MARK: - FORMAT TIME
  func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "H時mm分"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
  }
  
}
