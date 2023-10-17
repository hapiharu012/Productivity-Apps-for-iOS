//
//  AddTodoView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/11.
//

import SwiftUI
import Combine


struct AddTodoView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.managedObjectContext) var context
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var todoModel: TodoViewModel
  
  let priorities = ["高", "中", "低"]
  let textLimit = 20 //最大文字数
  
  @State private var errorShowing: Bool = false
  @State private var errorTitle: String = ""
  @State private var errorMessage = ""
  @State private var dateSetting = false
  @State private var timeSetting = false
  
  // フォーカスが当たるTextFieldを、判断するためのenumを作成します。
  enum Field: Hashable {
    case text
  }
  @FocusState private var focusedField: Field?
  
  // THEME
  @ObservedObject var theme = ThemeSettings.shared
  var themes: [Theme] = themeData
  // MARK: - BODY
  
  var body: some View {
    
    NavigationView{
      VStack {
        VStack(alignment: .leading, spacing: 20) {  //画面全体を覆うスクロールリストの生成
          // MARK: - TODO NAME
          TextField("Todo", text: $todoModel.name)
            .focused($focusedField, equals: .text)
            .padding()
          //            .background( r(UIColor.tertiarySystemFill))
            .background(themes[self.theme.themeSettings].rowColor)
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
            .onReceive(Just(todoModel.name)) { _ in
              if todoModel.name.count > textLimit {
                todoModel.name = String(todoModel.name.prefix(textLimit))
              }
            }

          
          //: - TODO PRI0RITIY
          
          HStack() {
            Text("優先度")
              .font(.footnote)
              .foregroundColor(getNavigationForegroudColor() ? .white : .black)
            //              .foregroundColor(.black)
            //              .foregroundStyle(Color("yellor"))
            Picker("優先度", selection: $todoModel.priority){
              ForEach(priorities, id: \.self) {
                Text($0) //メモ→   $0はクロージャが受け取る現在処理している要素を指す
              }
            }
            .pickerStyle(SegmentedPickerStyle())//ピッカーのデザインを変更
            .background(themes[self.theme.themeSettings].rowColor)
            .cornerRadius(9)
            .padding(.horizontal,10)
            //リセットボタン
            if todoModel.priority != "" {
              Button(action: {
                todoModel.priority = ""
              }) {
                Image(systemName: "clear")
                  .foregroundColor(themes[self.theme.themeSettings].accentColor)
                  .font(.system(size: 20, weight: .bold, design: .default))
              }
            }
          }
          .padding(10)
          
          // MARK: - TODO DEDLINE
          VStack {
            
            //MARK: - TODO DATE
            HStack {
              VStack(alignment: .leading) {
                Text("日付")
                  .font(.footnote)
                  .foregroundColor(getNavigationForegroudColor() ? .white : .black)
                
                
                if todoModel.deadline_date != nil {
                  Text(getTodayOrTomorrowOrDayAfterTomorrow(date: todoModel.deadline_date ?? Date()))
                    .foregroundColor(Color.blue)
                    .font(.footnote)
                }
              }
                            Spacer()
              //                .foregroundColor(.black)
              //                .foregroundStyle(Color("yellor"))
              
              if dateSetting {
                DatePicker(selection: Binding<Date>(
                  get: { self.todoModel.deadline_date ?? Date() },
                  set: { newValue in
                    print("Selected date:", newValue)
                    self.todoModel.deadline_date = newValue
                  }
                ), displayedComponents: .date, label: {
                  SwiftUI.EmptyView()
                }
                )
                .onAppear() {
                  if todoModel.deadline_date == nil {
                    todoModel.deadline_date = Date()
                  }
                }
                .onDisappear() {
                  if !dateSetting {
                    todoModel.deadline_date = nil
                  }
                }
                .padding(.leading, -8)
                .background(themes[self.theme.themeSettings].rowColor)
                .cornerRadius(9)
                .frame(width: 10,alignment: .leading)
                //                  .position(x: 102, y:15)
//                .offset(x: -100, y:0)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .padding(10)
                
              }
              Spacer()
                .frame(width: 90)
              Toggle(isOn: $dateSetting) {
                SwiftUI.EmptyView()
              }
              .toggleStyle(CustomToggleStyle())
              
              
            }
//            .position(x: 170, y: 0)
            //            Spacer()
            //               .frame(height: dateSetting ? 0 : 55)
            //MARK: - TODO TIME
            HStack {
              VStack(alignment: .leading) {
                Text("日時")
                  .font(.footnote)
                  .foregroundColor(getNavigationForegroudColor() ? .white : .black)
                
                
                if todoModel.deadline_time != nil {
                  Text(formatTime(date: todoModel.deadline_time ?? Date()))
                    .foregroundColor(Color.blue)
                    .font(.footnote)
                }
              }
                            Spacer()
              //                .foregroundColor(.black)
              //                .foregroundStyle(Color("yellor"))
              
              if timeSetting {
                DatePicker(selection: Binding<Date>(
                  get: { self.todoModel.deadline_time ?? Date() },
                  set: { newValue in
                    print("Selected date:", newValue)
                    self.todoModel.deadline_time = newValue
                  }
                ), displayedComponents: .hourAndMinute, label: {
                  SwiftUI.EmptyView()
                }
                )
                .onAppear() {
                  if todoModel.deadline_time == nil {
                    todoModel.deadline_time = Date()
                  }
                }
                .onDisappear() {
                  if !timeSetting {
                    todoModel.deadline_time = nil
                  }
                }
                .padding(.leading, -8)
                .background(themes[self.theme.themeSettings].rowColor)
                .cornerRadius(9)
                .frame(width: 10,alignment: .leading)
                //                  .position(x: 102, y:15)
//                .offset(x: -64, y:0)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .padding(10)
                
              }
              
              Spacer()
                .frame(width: 60)
              Toggle(isOn: $timeSetting) {
                SwiftUI.EmptyView()
              }
              .toggleStyle(CustomToggleStyle())

              
            }
//            .position(x:169,y:-140)
            Spacer()

            
          } //VStack
          .padding(.horizontal,10)
          
          //MARK: - SAVE BUTTON
          Button(action: {
            if todoModel.name != "" {
              print("保存ボタンが押されました")
              todoModel.writeTodo(context: context)
              UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } else {
              errorShowing = true
              errorTitle = "Todo名が入力されていません"
              errorMessage = "Todo名が入力されていないので入力してください。"
              return
            }
            presentationMode.wrappedValue.dismiss()
          }){
            Text("保存")
              .font(.system(size: 24, weight: .bold, design: .default))
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(themes[self.theme.themeSettings].accentColor)
              .cornerRadius(9)
            //              .foregroundColor(.white)
            //              .foregroundColor(Color("green"))
              .foregroundColor(getSaveButtonForegroudColor() ? .black : .white)
          }//END: SAVE BUTTON
        } //END: VSTACK
        .padding(.horizontal)
        .padding(.bottom, 30)
        
//        Spacer()
      } // END: VSTACK
      .background(themes[self.theme.themeSettings].backColor)
      .navigationBarTitle("New Todo", displayMode:.inline)
      .navigationBarItems(trailing:
                            Button(action: {
        presentationMode.wrappedValue.dismiss()  //dismiss関数は現在のViewを閉じる　＊しかし他のViewから呼ばれたViewではな場合は何も起きない
        todoModel.isNewTodo = false
      }) {
        Image(systemName: "xmark")
          .foregroundColor(themes[self.theme.themeSettings].accentColor)
          .padding()
      }
      )
      .toolbarBackground(themes[self.theme.themeSettings].backColor,for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(getNavigationForegroudColor() ? .dark : .light)
      //      .toolbarColorScheme(.light)
      // MARK: - ALERT
      .alert(isPresented: $errorShowing) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    } // END: NAVIGATION
    // MARK: - ON APPEAR
    .onAppear() {
      focusedField = .text
      dateSetting = { //期限の設定があるかどうかを判断
        if todoModel.deadline_date != nil {
          return true
        } else {
          return false
        }
      }()
      
      timeSetting = {
        if todoModel.deadline_time != nil {
          return true
        } else {
          return false
        }
      }()
//      
      
    }
    // MARK: - ON DISAPPEAR
    .onDisappear() {
      print("onDisappear - todoModel.isNewTodo: \(todoModel.isNewTodo)")
      todoModel.resetForm()
    }
    
  }
  func getNavigationForegroudColor() -> Bool {
    if themes[theme.themeSettings].themeName == "ミッドナイトブルー" ||
        themes[theme.themeSettings].themeName == "フォレストクリーム" {
      return true
    } else {
      return false
    }
  }
  func getSaveButtonForegroudColor() -> Bool {
    if themes[theme.themeSettings].themeName == "リフレッシュ" ||
        themes[theme.themeSettings].themeName == "フォレストクリーム" {
      return true
    } else {
      return false
    }
  }
//  // 日付をフォーマットする関数
//  func formatDate(date: Date) -> String {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .none
//    formatter.locale = Locale(identifier: "ja_JP")
//    return formatter.string(from: date)
//  }
  
  // 時刻をフォーマットする関数
  func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
  }
  
  
}//: BODY
func getTodayOrTomorrowOrDayAfterTomorrow(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "ja_JP")
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!
    if formatter.string(from: date) == formatter.string(from: today) {
      return "今日"
    } else if formatter.string(from: date) == formatter.string(from: tomorrow) {
      return "明日"
    } else if formatter.string(from: date) == formatter.string(from: dayAfterTomorrow) {
      return "明後日"
    } else {
      return formatter.string(from: date)
    }
  }

// MARK: - PREVIEW

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    //    AddTodoView(todoModel: TodoViewModel())
    AddTodoView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext))
    
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
