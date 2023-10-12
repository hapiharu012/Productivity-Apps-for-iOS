//
//  func.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import Foundation
import SwiftUI


private func formatDateTitleDayOfWeek(_ date: Date?) -> String {
  guard let date = date else { return "" }
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "ja_JP")
  formatter.dateFormat = "EE曜日"
  return formatter.string(from: date)
}
private func formatDateTitleDay(_ date: Date?) -> String {
  guard let date = date else { return "" }
  let formatter = DateFormatter()
  
  formatter.dateFormat = "d日"
  return formatter.string(from: date)
}
private func formatDate(_ date: Date?) -> String {
  guard let date = date else { return "" }
  let formatter = DateFormatter()
  formatter.dateFormat = "MM月dd日"
  return formatter.string(from: date)
}
private func determiningPriority (priority: String) -> Bool {
  switch priority {
  case "高":
    return true
  default:
    return false
  }
}
private func colorize(priority: String) -> Color {
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
