//
//  PriorityUtils.swift
//  Efficio
//
//  Created by Assistant on 2024/12/19.
//

import Foundation

/// 優先度関連のユーティリティ関数を提供する構造体
struct PriorityUtils {
  
  /// 優先度の数値を日本語のテキストに変換する
  /// - Parameter priority: 優先度の数値 (3: 高, 2: 中, 1: 低, 0: なし)
  /// - Returns: 優先度の日本語テキスト
  static func priorityText(for priority: Int16) -> String {
    switch priority {
    case 3: return "高"
    case 2: return "中"
    case 1: return "低"
    default: return "なし"
    }
  }
  
}
