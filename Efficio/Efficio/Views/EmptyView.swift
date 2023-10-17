//
//  EmptyView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/14.
//

import SwiftUI

struct EmptyView: View {
  // THEME
  @ObservedObject var theme: ThemeViewModel
  
  //MARK: - BODY

  var body: some View {
    
    // MARK: - ZSTACK
    
    ZStack {
      VStack(alignment: .center, spacing: 20) {
        Image("back")
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
          .layoutPriority(1)
          .foregroundColor(theme.accentColor)
        
        Text("Put hard tasks first.")
          .layoutPriority(0.5)
          .font(.system(.headline, design: .rounded))
          .foregroundColor(theme.accentColor)
      } //: VSTACK
      .padding(.horizontal)
    } //: ZSTACK
    
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(theme.backgroundColor)
    .edgesIgnoringSafeArea(.all)
  } //: BODY
  
} //: VIEW

////MARK: - PREVIEW
//struct EmptyView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyView()
//    }
//}
