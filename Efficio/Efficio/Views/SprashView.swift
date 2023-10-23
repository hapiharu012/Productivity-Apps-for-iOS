//
//  AprashView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/18.
//

import SwiftUI


struct SprashView: View {
  @State private var isLoading = false
  @State private var logoScale: CGFloat = 5.0
  @State private var rotation: Double = 0
  @State private var lgColor: Color = Color("Sprash_2")
  @State private var bgColor: Color = Color("Sprash_1")
  @State private var opacityNum: Double = 0
  
  
  var body: some View {
    ZStack {
      if isLoading {
        let persistenceController = PersistenceController.shared
        
        ContentView()
          .environment(\.managedObjectContext, persistenceController.container.viewContext)
          .onOpenURL { url in
          }
      }else {
        ZStack {
          bgColor.edgesIgnoringSafeArea(.all)
          
          Image("Logo") // こちらにロゴを配置
            .resizable()
            .renderingMode(.template)
            .foregroundColor(lgColor)
            .scaledToFit()
            .frame(width: 200, height: 200)
            .scaleEffect(logoScale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacityNum)
        }
        .onAppear() {
          withAnimation(Animation.spring().delay(0.8).repeatCount(1, autoreverses: false)) {
            logoScale = 1.3
            rotation = 360
            lgColor = Color("Sprash_1")
            bgColor = Color("Sprash_2")
            opacityNum = 1
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            isLoading = true
          }
        }
      }
    }
  }
}


//  struct SprashView_Previews: PreviewProvider {
//      static var previews: some View {
//        SprashView()
//      }
//  }
