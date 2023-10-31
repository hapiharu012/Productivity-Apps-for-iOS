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
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  //MARK: - BODY

  var body: some View {
    
    // MARK: - ZSTACK
    
    ZStack {
      VStack(alignment: .center, spacing: 10) {
        Image("back")
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
          .layoutPriority(1)
          .foregroundColor(theme.accentColor)
        
        VStack {
          Text("75%")
            .fontWeight(.heavy)
//            .foregroundColor(theme.backgroundColor)
            .foregroundColor(theme.determineEmptyViewFontColor(for: colorScheme) ? .black : theme.backgroundColor)
            .font(.system(.title, design: .rounded))
            .padding(.top)
          Text("この数字が何だかわかりますか？")
            .font(.title3)
            .foregroundColor(theme.determineEmptyViewFontColor(for: colorScheme) ? .black : theme.backgroundColor)
          (
            Text("Todoリストに書いてあるタスクの中で無駄なタスクの割合です。Todoリストをつけた場合半分(50%)は手をつけられないタスク、さらに残りの半分の半分(25%)は手をつければ5分以内で終わる様なタスクだと言われています。最低限をリストアップし今日の「")
            +
            Text("マストワン")
              .bold()
              .font(.title3)
            +
            Text("」(Todoリストの優先度の高いタスク)を決めてから1日を過ごしましょう。")
            
          )
          .lineSpacing(3)
          .layoutPriority(0.5)
          .font(.system(.footnote, design: .rounded))
          .foregroundColor(theme.determineEmptyViewFontColor(for: colorScheme) ? .black : theme.backgroundColor)
          
          .padding()
        }.background(theme.accentColor)
          .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke(theme.accentColor, lineWidth: 1)
//            .contrast(3.0)
          )
          .clipShape(RoundedRectangle(cornerRadius: 20))
      } //: VSTACK
      .padding(.horizontal)
    } //: ZSTACK
    
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(theme.backgroundColor)
    .edgesIgnoringSafeArea(.all)
  } //: BODY
  
} //: VIEW

//MARK: - PREVIEW
struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(theme: ThemeViewModel.shared)
    }
}
