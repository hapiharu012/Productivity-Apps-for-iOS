//
//  ThemeModel.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/15.
//

import SwiftUI

// MARK: - THEME MODEL

struct Theme: Identifiable {
  let id: Int
  let themeName: String
  let backColor: Color
  let rowColor: Color
  let accentColor: Color
}
