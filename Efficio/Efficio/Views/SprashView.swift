//
//  AprashView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/18.
//

import SwiftUI


  struct SprashView: View {
      @State private var isLoading = true

    var body: some View {
      if isLoading {
        ZStack {
          Color("WtoB")
            .ignoresSafeArea(.all)
          Image("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
              isLoading = false
            }
          }
        }
      } else {
        let persistenceController = PersistenceController.shared
        
        ContentView()
          .environment(\.managedObjectContext, persistenceController.container.viewContext)
          .onOpenURL { url in
                  print("Received deep link: \(url)")
                }
      }
    }
  }
//
//  struct SprashView_Previews: PreviewProvider {
//      static var previews: some View {
//        SprashView()
//      }
//  }
