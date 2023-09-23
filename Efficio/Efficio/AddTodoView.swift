//
//  AddTodoView.swift
//  ToDo-List
//
//  Created by 2023_intern05 on 2023/09/11.
//

import SwiftUI
import WidgetKit
import Combine


struct AddTodoView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    /*
     メモ→ presentationMode構造体は次の二つの機能を実現する
     ・現在のViewが他のViewから呼ばれているかどうかを示すフラグ
     ・現在のViewを閉じる処理
     */
    
    @State private var name: String = "" //todo名
    @State private var priority: String = "中" //優先度(通常は中)
    @State private var state: Bool =  false //実行状況
    @State private var dedline: Date = Date() //期限
    
    let priorities = ["高", "中", "低"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage = ""
    let textLimit = 20 //最大文字数
    // フォーカスが当たるTextFieldを、判断するためのenumを作成します。
    enum Field: Hashable {
        case text
    }
//    @FocusState private var focusedField: Field?
    
    // MARK: - BODY
    var body: some View {
        NavigationView{
            VStack {
                VStack(alignment: .leading, spacing: 20) {  //画面全体を覆うスクロールリストの生成
                    // MARK: - TODO NAME
                    TextField("Todo", text: $name)
//                        .focused($focusedField, equals: .text)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .onReceive(Just(name)) { _ in
                            if name.count > textLimit {
                                name = String(name.prefix(textLimit))
                            }
                        }
                    
                    // MARK: - TODO PRI0RITIY
                    Picker("優先度", selection: $priority){
                        ForEach(priorities, id: \.self) {
                            Text($0) //メモ→   $0はクロージャが受け取る現在処理している要素を指す
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())//ピッカーのデザインを変更
                    .padding(10)
                    
                    // MARK: - TODO DEDLINE
                    DatePicker(selection: $dedline, label: {
                        Text("期限")
                    })
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .padding(10)
                    
                    //MARK: - SAVE BUTTON
                    Button(action: {
                        if self.name != "" {
                            let todo = Todo(context: managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            todo.state = self.state
                            todo.deadline = self.dedline
                            do {
                                try managedObjectContext.save()
                                print("New todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                            } catch {
                                print(error)
                            }
                            do {
                                try managedObjectContext.save()
                                // 追加
                                WidgetCenter.shared.reloadAllTimelines()
                                
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
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
                
            }) {
                Image(systemName: "xmark")
            }
            )
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        } // END: NAVIGATION
//        .onAppear() {
//            focusedField = .text
//        }
    }
}

// MARK: - PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
