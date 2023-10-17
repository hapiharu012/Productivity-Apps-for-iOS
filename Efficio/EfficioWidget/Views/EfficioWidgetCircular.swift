//
//  EfficioWidgetCircular.swift
//  EfficioWidgetExtension
//
//  Created by hapiharu012 on 2023/10/17.
//

import SwiftUI
import WidgetKit

struct EfficioWidgetCircular: View {
  
    var body: some View {
        Link(destination: URL(string: "addTodo://")!) {
          Circle().fill()
            .foregroundColor(.white)
            .shadow(radius: 2)
          
            .overlay(
              Image(systemName: "note.text.badge.plus")
                .resizable()
                .foregroundColor(Color("WtoB"))
                .scaledToFit()
                .frame(width: 45)
                .position(CGPoint(x: 33.0, y: 31.0))
              )
        } //: LINK
        .widgetBackground(Color("BtoW"))
    } //: BODY
} //: VIEW

// MARK: - PREVIEW
struct EfficioWidgetCircular_Previews: PreviewProvider {
  static var previews: some View {
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
  }
}
