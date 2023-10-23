//
//  File.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/06.
//

import SwiftUI

struct EmptyWidget: View {
  var point:CGFloat
  var body: some View {
    
    Text("全てのタスクが完了しました。")
//      .font(.caption)
      .font(.system(size: point, weight: .light, design: .default))
      .foregroundStyle(.gray)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
//      .widgetBackground(Color("BtoW"))
      .widgetBackground(Color("WidgetBackground"))

  } //: BODY
} //: VIEW

// MARK: - PREVIEW
struct EmptyWidget_Previews: PreviewProvider {
  static var previews: some View {
    EmptyWidget(point: 10)
  }
}
