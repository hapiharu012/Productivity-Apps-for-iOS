//
//  EmptyView.swift
//  ToDo-List
//
//  Created by 2023_intern05 on 2023/09/14.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
      ZStack {
        VStack(alignment: .center, spacing: 20) {
          Image("back")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
            .layoutPriority(1)
            .foregroundColor(.blue)
          
          Text("Put hard tasks first.")
            .layoutPriority(0.5)
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.blue)
        } //: VSTACK
          .padding(.horizontal)
          //.opacity(isAnimated ? 1 : 0)
          //.offset(y: isAnimated ? 0 : -50)
          //.animation(.easeOut(duration: 1.5))
          //.onAppear(perform: {
            // self.isAnimated.toggle()
          //})
      } //: ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
