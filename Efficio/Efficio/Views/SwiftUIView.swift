//
//  SwiftUIView.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/19.
//

import SwiftUI

struct SwiftUIView: View {
  @State var dateSetting = false
  var body: some View {
    Toggle(isOn: $dateSetting) {
      Text("Date")
    }
  }
}
#Preview {
    SwiftUIView()
}
