//
//  ToggleIntent.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/02.
//

//import Foundation
import AppIntents

struct ToggleIntent: AppIntent {
  
  
  func perform(state:Bool) async throws -> some IntentResult {
    // 実行したい処理
    togglState()
    return .result()
  }
}
