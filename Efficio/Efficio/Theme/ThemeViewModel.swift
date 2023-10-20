//
//  ThemeSetting.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/15.
//

import SwiftUI

// MARK: - THEME CLASS

final public class ThemeViewModel: ObservableObject {
  
  @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
  
  var themes: [Theme] = themeData
  
  var backgroundColor: Color {
    themes[themeSettings].backColor
  }
  
  var rowColor: Color {
    themes[themeSettings].rowColor
  }
  
  var accentColor: Color {
    themes[themeSettings].accentColor
  }
  
  var themeName: String {
    themes[self.themeSettings].themeName
  }
  
  // MARK - GET NAVIGATION FOREGROUND COLOR
  func determineTheFontColor(for colorScheme : ColorScheme) -> Bool {
    if themeName == "ミッドナイトブルー" ||
        themeName == "フォレストクリーム" {
      return true//.dark: 白
    } else {
      if colorScheme == .dark {
        return true // .dark: 白
      }
      return false // .light: 黒
    }
  }
  
  func determineEmptyViewFontColor(for colorScheme : ColorScheme) -> Bool {
    if themeName == "リフレッシュ" {
      if colorScheme == .dark {
        return false // .dark: 白
      }
      return true//.dark: 白
    } else {
      return false // .light: 黒
    }
  }
  
  // MARK - GET SAVE BUTTON FOREGROUND COLOR
  func getSaveButtonForegroudColor() -> Bool {
    if themeName == "リフレッシュ" ||
        themeName == "フォレストクリーム" {
      return true
    } else {
      return false
    }
  }
  private init() {}
  public static let shared = ThemeViewModel()
}
