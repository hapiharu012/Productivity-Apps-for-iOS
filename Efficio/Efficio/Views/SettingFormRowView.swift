//
//  SettingFormRowView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/15.
//

import SwiftUI

struct SettingFormRowView: View {
  // MARK: - PROPERTIES
  
  var icon: String
  var firstText: String
  var secondText: String
  
  // MARK: - BODY
  var body: some View {
    HStack {
      ZStack {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(Color.gray)
        Image(systemName: icon)
          .foregroundColor(Color.white)
      }
      .frame(width: 36, height: 36, alignment: .center)
      
      Text(firstText).foregroundColor(Color.gray)
      Spacer()
      Text(secondText)
    } //: HSTACK
    
  } //: BODY
} //: VIEW


// MARK: - PREVIEW

struct FormRowStaticView_Previews: PreviewProvider {
  static var previews: some View {
    SettingFormRowView(icon: "gear", firstText: "Application", secondText: "Todo")
  }
}
