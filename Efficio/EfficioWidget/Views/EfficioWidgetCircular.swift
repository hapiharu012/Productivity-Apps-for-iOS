//
//  EfficioWidgetCircular.swift
//  EfficioWidgetExtension
//
//  Created by k21123kk on 2023/10/17.
//

import SwiftUI
import WidgetKit

struct EfficioWidgetCircular: View {
    var body: some View {
        Link(destination: URL(string: "addTodo://")!) {
          Circle().fill()
            .foregroundColor(.white)
//              .foregroundColor(themes[self.theme.themeSettings].backColor)
            .shadow(radius: 2)
          
            .overlay(
              Image(systemName: "note.text.badge.plus")
                .resizable()
                .foregroundColor(.black)
//                  .foregroundColor(themes[self.theme.themeSettings].accentColor)
                .scaledToFit()
                .frame(width: 45)
                .position(CGPoint(x: 33.0, y: 31.0))
              )
        }
        .widgetBackground(Color.white)
    }
}

struct EfficioWidgetCircular_Previews: PreviewProvider {
  static var previews: some View {
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
  }
}
