//
//  SettingFormRowLinkView.swift
//  Efficio
//
//  Created by k21123kk on 2023/11/01.
//

import SwiftUI

struct SettingFormRowLinkView: View {
  // MARK: - PROPERTIES
  
  var icon: String
  var color: Color
  var text: String
  var link: String
  
  // MARK: - BODY
  
  var body: some View {
    HStack {
      ZStack {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(color)
        Image(systemName: icon)
          .imageScale(.large)
          .foregroundColor(Color.white)
      }
      .frame(width: 36, height: 36, alignment: .center)
      
      Text(text).foregroundColor(Color.gray)
      
      Spacer()
      
      Button(action: {
        // OPEN A LINK
        if link == "review" {
          reviewApp()
        }else {
          guard let url = URL(string: self.link), UIApplication.shared.canOpenURL(url) else {
            return
          }
          UIApplication.shared.open(url as URL)
        }}
        ) {
          Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .accentColor(Color(.systemGray2))
      }
  }
  func reviewApp(){
        let productURL:URL = URL(string: "https://apps.apple.com/jp/app/%E3%82%A8%E3%83%95%E3%82%A3%E3%82%B7%E3%82%AA-efficio-%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%8F%E3%81%AA%E3%82%8B%E7%94%9F%E7%94%A3%E6%80%A7%E5%90%91%E4%B8%8A%E3%82%A2%E3%83%97%E3%83%AA/id6470177037")!
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
}
