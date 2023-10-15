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
  // フォーカスが当たるTextFieldを、判断するためのenumを作成します。
  enum Field: Hashable {
    case text
  }
  @FocusState private var focusedField: Field?
  
  
  // MARK: - BODY
  
  var body: some View {
    
    NavigationView{
      VStack {
        VStack(alignment: .leading, spacing: 20) {  //画面全体を覆うスクロールリストの生成
          // MARK: - TODO NAME
          TextField("Todo", text: $todoModel.name)
            .focused($focusedField, equals: .text)
            .padding()
//            .background(Color(UIColor.tertiarySystemFill))
            .background(Color("yellor"))
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
            .onReceive(Just(todoModel.name)) { _ in
              if todoModel.name.count > textLimit {
                todoModel.name = String(todoModel.name.prefix(textLimit))
              }
            }
          
          //: - TODO PRI0RITIY
          
          HStack( spacing: 5) {
            Text("優先度")
              .font(.footnote)
              .foregroundColor(.white)
//              .foregroundColor(.black)
//              .foregroundStyle(Color("yellor"))
            Picker("優先度", selection: $todoModel.priority){
              ForEach(priorities, id: \.self) {
                Text($0) //メモ→   $0はクロージャが受け取る現在処理している要素を指す
              }
            }
            .pickerStyle(SegmentedPickerStyle())//ピッカーのデザインを変更
            .background(Color("yellor"))
            .cornerRadius(9)
          .padding(10)
          }.padding(10)
          
          // MARK: - TODO DEDLINE
          VStack {
            HStack {
              Text("期限")
                .font(.footnote)
                .foregroundColor(.white)
//                .foregroundColor(.black)
//                .foregroundStyle(Color("yellor"))

             
                Toggle(isOn: $dateSetting) {
                  SwiftUI.EmptyView()
                }
                  .toggleStyle(CustomToggleStyle())
  //              .cornerRadius()
  //              .toggleStyle(SwitchToggleStyle(tint: Color.red))
              
            }
              if dateSetting {
                  DatePicker(selection: Binding<Date>(
                    get: { self.todoModel.deadline ?? Date() },
                    set: { newValue in
                      print("Selected date:", newValue)
                      self.todoModel.deadline = newValue
                    }
                  ), label: {
                    SwiftUI.EmptyView()
                  }
                  ).onAppear() {
                    if todoModel.deadline == nil {
                      todoModel.deadline = Date()
                    }
                  }
                  .onDisappear() {
                    todoModel.deadline = nil
                  }
                  .padding(.leading, -8)
                  .background(Color("yellor"))
                  .cornerRadius(9)
                  .frame(width: 10,alignment: .leading)
                  .offset(x: 10)
                  .environment(\.locale, Locale(identifier: "ja_JP"))
                  
            }
            
          }.padding(10)
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
              .background(Color("orange"))
              .cornerRadius(9)
//              .foregroundColor(.white)
//              .foregroundColor(Color("green"))
              .foregroundColor(.black)
          }//END: SAVE BUTTON
        } //END: VSTACK
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        Spacer()
      } // END: VSTACK
      .background(Color("green"))
      .navigationBarTitle("New Todo", displayMode:.inline)
      .navigationBarItems(trailing:
                            Button(action: {
        presentationMode.wrappedValue.dismiss()  //dismiss関数は現在のViewを閉じる　＊しかし他のViewから呼ばれたViewではな場合は何も起きない
        todoModel.isNewTodo = false
      }) {
        Image(systemName: "xmark")
          .foregroundColor(Color("orange"))
      }
      )
      .toolbarBackground(Color("green"),for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(.dark)
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
        if todoModel.deadline != nil {
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

  }

}//: BODY


// MARK: - PREVIEW

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
//    AddTodoView(todoModel: TodoViewModel())
    AddTodoView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext))

      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
