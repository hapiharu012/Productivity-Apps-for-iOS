//
//  ViewExtension.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/18.
//

import SwiftUI

extension View {
  func widgetBackground(_ backgroundView: some View) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      return containerBackground(for: .widget) {
        Color.clear
      }
    } else {
      return background(Color.clear)
    }
  }
  
}
