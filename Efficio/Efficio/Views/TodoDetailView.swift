//
//  TodoDetailView.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import SwiftUI

struct TodoDetailView: View {
  @Environment(\.managedObjectContext) var context
  @ObservedObject var todoModel: TodoModel
  @ObservedObject var todo: Todo
  
  @FocusState private var focusedField: Bool
  var body: some View {
    HStack{
      TextField("", text: Binding($todo.name)!)
        .textFieldStyle(RoundedBorderTextFieldStyle())
              .keyboardType(.default)
              .focused($focusedField)  // このTextFieldのフォーカスをBool値で取得、操作
        .padding()
      Spacer()
      Button(action: {
        todoModel.isEditing = todo
        todoModel.writeTodo(context: context)
      }, label: {
        Image(systemName: "externaldrive.fill.badge.checkmark")
          .foregroundColor(.red)
      })
    }
    //
  }
}



//// MARK: - PREVIEW
//struct TodoDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoDetailView(todoModel: TodoModel(), todo: <#Todo#>).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}
//T
