//
//  SettingView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/15.
//
import SwiftUI

struct SettingsView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.presentationMode) var presentationMode
  
  // THEME
  
  let themes: [Theme] = themeData
  @ObservedObject var theme = ThemeSettings.shared
  @State private var isThemeChanged: Bool = false
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      VStack(alignment: .center, spacing: 0) {
        // MARK: - FORM
        
        Form {
          // MARK: - SECTION 2
          Section(header:
            HStack {
              Text("テーマを変更:")
              Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundColor(themes[self.theme.themeSettings].backColor)
            }
          ) {
            List {
              ForEach(themes, id: \.id) { item in
                Button(action: {
                  self.theme.themeSettings = item.id
                  UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                  self.isThemeChanged.toggle()
                }) {
                  HStack {
                    Image(systemName: "circle.fill")
                      .foregroundColor(item.backColor)
                    
                    Text(item.themeName)
                  }
                } //: BUTTON
                  .accentColor(Color.primary)
              }
            }
          } //: SECTION 2
            .padding(.vertical, 3)
            .alert(isPresented: $isThemeChanged) {
              Alert(
                title: Text("SUCCESS!"),
                message: Text("App has been changed to the \(themes[self.theme.themeSettings].themeName)!"),
                dismissButton: .default(Text("OK"))
              )
          }
          
          // MARK: - SECTION 4
          
          Section(header: Text("アプリケーションについて")) {
            SettingFormRowView(icon: "gear", firstText: "アプリケーション", secondText: "Efficio")
            SettingFormRowView(icon: "checkmark.seal", firstText: "互換性", secondText: "iPhone, iPad")
            SettingFormRowView(icon: "keyboard", firstText: "開発者", secondText: "Haruto Morishige")
            SettingFormRowView(icon: "flag", firstText: "バージョン", secondText: "1.0.0")
          } //: SECTION 4
            .padding(.vertical, 3)
          
        } //: FORM
          .listStyle(GroupedListStyle())
          .environment(\.horizontalSizeClass, .regular)
        
        // MARK: - FOOTER
        
        Text("Copyright © All rights reserved.")
          .multilineTextAlignment(.center)
          .font(.footnote)
          .padding(.top, 6)
          .padding(.bottom, 8)
          .foregroundColor(Color.secondary)
      } //: VSTACK
        .navigationBarItems(trailing:
          Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "xmark")
          }
        )
        .navigationBarTitle("Settings", displayMode: .inline)
        .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
    } //: NAVIGATION
      .accentColor(themes[self.theme.themeSettings].backColor)
      .navigationViewStyle(StackNavigationViewStyle())
  }//: BODY
}//: SETTINGS

// MARK: - PREIVEW

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}


//#Preview {
//    SettingView()
//}
