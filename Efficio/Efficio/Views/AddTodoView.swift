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
  @ObservedObject var theme: ThemeViewModel
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  
  let calendar = Calendar.current
  
  // MARK: - BODY
  
  var body: some View {
    
    NavigationView{
      VStack {
        VStack(alignment: .leading, spacing: 20) {  //画面全体を覆うスクロールリストの生成
          
          // MARK: - TODO NAME
          TextField("Todo", text: $todoModel.name)
            .focused($focusedField, equals: .text)
            .padding()
            .background(theme.rowColor)
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
              .foregroundColor(theme.getNavigationForegroundColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black)
            
            //MARK: - PRIORITY PICKER
            Picker("優先度", selection: $todoModel.priority){
              ForEach(priorities, id: \.self) {
                Text($0) //メモ→   $0はクロージャが受け取る現在処理している要素を指す
              }
            }
            .pickerStyle(SegmentedPickerStyle())//ピッカーのデザインを変更
            .background(theme.rowColor)
            .cornerRadius(9)
            .padding(.horizontal,10)
            //リセットボタン
            if todoModel.priority != "" {
              Button(action: {
                todoModel.priority = ""
              }) {
                Image(systemName: "clear")
                  .foregroundColor(theme.accentColor)
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
                  .foregroundColor(theme.getNavigationForegroundColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black)
               
              }
              Spacer()
              
              // MARK: - TODO DATE PICKER
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
                .background(theme.rowColor)
                .cornerRadius(9)
                .frame(width: 10,alignment: .leading)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .padding(10)
                
              }
              
              Spacer()
                .frame(width: 90)
              
              // MARK: - TODO DATE TOGGLE
              Toggle(isOn: $dateSetting) {
                SwiftUI.EmptyView()
              }
              .toggleStyle(CustomToggleStyle())
              
              
            }
            
            //MARK: - TODO TIME
            HStack {
              VStack(alignment: .leading) {
                Text("日時")
                  .font(.footnote)
                  .foregroundColor(theme.getNavigationForegroundColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black)
                
                
                if todoModel.deadline_time != nil {
                  Text(calendar.formatTime(date: todoModel.deadline_time!))
                    .foregroundColor(Color.blue)
                    .font(.footnote)
                }
              }
              Spacer()
              
              // MARK: - TODO TIME PICKER
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
                .background(theme.rowColor)
                .cornerRadius(9)
                .frame(width: 10,alignment: .leading)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .padding(10)
              }
              
              Spacer()
                .frame(width: 60)
              
              //MARK: - TODO TIME TOGGLE
              Toggle(isOn: $timeSetting) {
                SwiftUI.EmptyView()
              }
              .toggleStyle(CustomToggleStyle())
            }
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
              .background(theme.accentColor)
              .cornerRadius(9)
              .foregroundColor(theme.getSaveButtonForegroudColor() ? .black : colorScheme == .dark ? .black : .white)
          } //: SAVE BUTTON
        } //: VSTACK
        .padding(.horizontal)
        .padding(.vertical, 10)
        
      } // : VSTACK
      .background(theme.backgroundColor)
      .navigationBarTitle("New Todo", displayMode:.inline)
      .navigationBarItems(trailing:
                            Button(action: {
        presentationMode.wrappedValue.dismiss()  //dismiss関数は現在のViewを閉じる　＊しかし他のViewから呼ばれたViewではな場合は何も起きない
        todoModel.isNewTodo = false
      }) {
        Image(systemName: "xmark")
          .foregroundColor(theme.accentColor)
          .padding()
      }
      )
      .toolbarBackground(theme.backgroundColor,for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(theme.getNavigationForegroundColor(for: colorScheme) ? .dark : .light)
      
      // MARK: - ALERT
      .alert(isPresented: $errorShowing) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    } // : NAVIGATION
    
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
    }
    
    // MARK: - ON DISAPPEAR
    .onDisappear() {
      print("onDisappear - todoModel.isNewTodo: \(todoModel.isNewTodo)")
      todoModel.resetForm()
    }
    
  } // : BODY
} //: VIEW

// MARK: - PREVIEW

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), theme: ThemeViewModel.shared)
    
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
