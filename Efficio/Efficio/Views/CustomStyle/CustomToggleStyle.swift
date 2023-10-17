//
//  ToggleView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/15.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
//        HStack {
//            configuration.label
//            Spacer()
            Rectangle()
                .fill(configuration.isOn ? Color.green : Color("Toggle")) // ONの時は青、OFFの時は赤にする
                .frame(width: 49, height: 30, alignment: .center)
                .cornerRadius(100)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .padding(4)
                        .offset(x: configuration.isOn ? 9.7 : -9.6)
                        .shadow(radius: 2)
                )
                
                .onTapGesture {
                    configuration.isOn.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
//        }
    }
}

//#Preview {
//  Toggle("", isOn: .constant(true))
//    .toggleStyle(CustomToggleStyle())
//}
