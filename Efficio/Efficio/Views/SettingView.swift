//
//  SettingView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/15.
//
import SwiftUI
//import WidgetKit
struct SettingsView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.presentationMode) var presentationMode
  
  // THEME
  @ObservedObject var theme : ThemeViewModel
  
  
  @State private var isThemeChanged: Bool = false
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  
  // MARK: - BODY
  var body: some View {
    NavigationView {
      VStack(alignment: .center, spacing: 0) {
        // MARK: - FORM
        
        Form {
          // MARK: - THEME SECTION
          Section(header:
                    HStack {
            Text("テーマを変更:")
              .foregroundStyle(colorScheme == .dark ? .white : .black)
            Image(systemName: "circle.fill")
              .resizable()
              .frame(width: 10, height: 10)
              .foregroundColor(theme.backgroundColor)
          }
          ) {
            List {
              ForEach(theme.themes, id: \.id) { item in
                Button(action: {
                  self.theme.themeSettings = item.id
                  UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                  self.isThemeChanged.toggle()
                }) {
                  HStack {
                    Image(systemName: "circle.fill")
                      .foregroundColor(item.backColor)
                    
                    Text(item.themeName)
                      .foregroundStyle(colorScheme == .dark ? .white : .black)
                  }
                } //: BUTTON
                .accentColor(Color.primary)
              }
            }
          } //: THEME SECTION
          
          .padding(.vertical, 3)
          
          
          // MARK: - ABOUT APP SECTION
          Section(header: Text("アプリケーションについて")) {
            SettingFormRowView(icon: "gear", firstText: "アプリケーション", secondText: "Efficio")
            SettingFormRowLinkView(icon: "person.bubble", color: .pink, text: "問い合わせ", link: "https://docs.google.com/forms/d/e/1FAIpQLScSn_b26BJZBd7NgM2XPN-_oiEIzeDF9sqbOG_DW81hHDj5pw/viewform")
            SettingFormRowLinkView(icon: "star", color: .blue, text: "AppStoreでレビューを書く", link: "review")
            SettingFormRowLinkView(icon: "externaldrive.badge.icloud", color: .gray, text: "プライバシーポリシー", link: "https://www.notion.so/hapiharu012/Efficio-36096a247127491bb3f3c0f4da64da75?pvs=4")
          } //: ABOUT APP SECTION
          .padding(.vertical, 3)
          .foregroundStyle(colorScheme == .dark ? .white : .black)
          
          Section {
            SettingFormRowView(icon: "checkmark.seal", firstText: "互換性", secondText: "iPhone, iPad")
            SettingFormRowView(icon: "keyboard", firstText: "開発者", secondText: "Haruto Morishige")
            SettingFormRowView(icon: "flag", firstText: "バージョン", secondText: "1.1.0")
          } //: ABOUT APP SECTION
          .padding(.vertical, 3)
          .foregroundStyle(colorScheme == .dark ? .white : .black)
          
        } //: FORM
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .foregroundStyle(colorScheme == .dark ? .white : .black)
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
          .padding()
          .foregroundColor(colorScheme == .dark ? .white : .black)
      }
      )
      .navigationBarTitle("Settings", displayMode: .inline)
    } //: NAVIGATION
    .navigationViewStyle(StackNavigationViewStyle())
    .accentColor(theme.backgroundColor)
    .alert(isPresented: $isThemeChanged) {
      Alert(
        title: Text("テーマを変更しました。"),
        message: Text("変更後 :  \(theme.themeName)"),
        dismissButton: .default(Text("OK"),action: {
          isThemeChanged = false
        })
      )
    }
    
  }//: BODY
 
}//: SETTINGS

// MARK: - PREIVEW

//struct SettingsView_Previews: PreviewProvider {
//  static var previews: some View {
//    SettingsView()
//  }
//}
