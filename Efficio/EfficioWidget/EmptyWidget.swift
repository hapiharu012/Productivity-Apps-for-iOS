//
//  File.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI

struct EmptyWidget: View {
  var body: some View {
    Text("全てのタスクが完了しました。")
//      .font(.caption)
      .font(.system(size: 15, weight: .light, design: .default))
      .foregroundStyle(.gray)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct EmptyWidget_Previews: PreviewProvider {
  static var previews: some View {
    EmptyWidget()
  }
}
