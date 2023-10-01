//
//  AddTodoView.swift
//  ToDo-List
//
//  Created by 2023_intern05 on 2023/09/11.
//

import SwiftUI
import Combine


struct AddTodoView: View {
  // MARK: - PROPERTIES
  @Environment(\.managedObjectContext) var context
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var todoModel: TodoModel
  
  let priorities = ["高", "中", "低"]
  let textLimit = 20 //最大文字数
  
  @State private var errorShowing: Bool = false
  @State private var errorTitle: String = ""
  @State private var errorMessage = ""
  
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
            .background(Color(UIColor.tertiarySystemFill))
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
            .onReceive(Just(todoModel.name)) { _ in
              if todoModel.name.count > textLimit {
                todoModel.name = String(todoModel.name.prefix(textLimit))
              }
            }
          
          // MARK: - TODO PRI0RITIY
          
          Picker("優先度", selection: $todoModel.priority){
            ForEach(priorities, id: \.self) {
              Text($0) //メモ→   $0はクロージャが受け取る現在処理している要素を指す
            }
          }
          .pickerStyle(SegmentedPickerStyle())//ピッカーのデザインを変更
          .padding(10)
          
          // MARK: - TODO DEDLINE
          DatePicker(selection: Binding<Date>(
            get: { self.todoModel.deadline ?? Date() },
            set: { newValue in
              print("Selected date:", newValue)
              self.todoModel.deadline = newValue
            }
          ), label: {
            Text("期限")
              .font(.footnote)
          }).onTapGesture {
            if todoModel.deadline == nil {
              todoModel.deadline = Date()
            }
          }
          .environment(\.locale, Locale(identifier: "ja_JP"))
          .padding(10)
          
          //MARK: - SAVE BUTTON
          Button(action: {
            if todoModel.name != "" {
              print("保存ボタンが押されました")
              
              todoModel.writeTodo(context: context)
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
              .background(Color.blue)
              .cornerRadius(9)
              .foregroundColor(.white)
          }//END: SAVE BUTTON
        } //END: VSTACK
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        Spacer()
      } // END: VSTACK
      .navigationBarTitle("New Todo", displayMode:.inline)
      .navigationBarItems(trailing:
                            Button(action: {
        presentationMode.wrappedValue.dismiss() //dismiss関数は現在のViewを閉じる　＊しかし他のViewから呼ばれたViewではな場合は何も起きない
        todoModel.isNewTodo = false
      }) {
        Image(systemName: "xmark")
      }
      )
      .alert(isPresented: $errorShowing) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    } // END: NAVIGATION
    // MARK: - ON APPEAR
    .onAppear() {
      focusedField = .text
    }
    // MARK: - ON DISAPPEAR
    .onDisappear() {
      print("onDisappear - todoModel.isNewTodo: \(todoModel.isNewTodo)")
      todoModel.resetData()
    }
  }
}

// MARK: - PREVIEW
struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView(todoModel: TodoModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
