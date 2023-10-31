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
  
  
  // MARK: - PADDING SETTINGS FOR EACH OS
    @ViewBuilder
  func mediumWidgetPaddingSettingsForEachOs() -> some View {
      if #available(iOS 17.0, *) {
        self.padding(-2)
      } else {
        self.padding(.all,10)
      }
    }
  
  
    @ViewBuilder
    func smallWidgetPaddingSettingsForEachOs() -> some View {
      if #available(iOS 17.0, *) {
        self.padding(0)
      } else {
        self.padding(15)
        }
      }
    
  

  
  
}
