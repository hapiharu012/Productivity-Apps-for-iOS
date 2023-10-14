//
//  TodoItemView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/09/25.
//

import SwiftUI

struct TodoItemView: View {
  // MARK: - PROPERTIES

  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var todo: Todo
  
  
  // MARK: - BODY

  var body: some View {
    HStack {
      // MARK: - CHECKMARK
      Image(systemName: todo.state ? "checkmark.circle" : "circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedName) ? .red : .black))
      // MARK: - CHECKMARK ONTAPGESTURE
        .onTapGesture {
          todoModel.toggleTodoState(for: todo)
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      // MARK: - TODO NAME
      Text(todo.wrappedName)
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .strikethrough(todo.state, color: .black)
        .offset(x: 10)
      Spacer()
      // MARK: - DEADLINE
      if todo.deadline != nil{
        HStack {
          Image(systemName: "calendar")
          Text(dateFormatting(todo.deadline))
        }
        .font(.footnote)
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .opacity(0.5)
      }
      // MARK: - PRIORITY
      if todo.priority != "" {
        Text(todo.priority ?? "")
          .font(.footnote)
          .foregroundColor(Color(UIColor.systemGray2))
          .padding(3)
          .frame(minWidth: 62)
          .overlay(
            Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
        )
      }
    } //: HSTACK
//    .padding(.vertical, 8)
//    .background(.gray)
    
    // MARK: - ONTAPGESTURE
    .onTapGesture {
      // 編集画面のsheetが出るようにする
      todoModel.editTodo(todo: todo)
    }
  }// END: BODY
  
  
  // MARK: - FUNCTIONS
  
  private func dateFormatting(_ date: Date?) -> String {
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日"
    return formatter.string(from: date)
  }

  private func priorityJudgment (priority: String) -> Bool {
    switch priority {
    case "高":
      return true
    default:
      return false
    }
  }
  
} //: TODOITEMVIEW


// MARK: - PREVIEW

struct TodoItemView_Previews: PreviewProvider {
  static var previews: some View {
    let todo = Todo(context: PersistenceController.preview.container.viewContext)
    todo.name = "サンプルTodo"
    todo.priority = "中"
    todo.state = false
    todo.deadline = Date()
    todo.id = UUID()
    
//    todo.name = "サンプルTodo"
//    todo.priority = ""
//    todo.state = false
//    todo.deadline = nil
//    todo.id = UUID()
    
//    return TodoItemView(todoModel: TodoViewModel(), todo: todo)
    return TodoItemView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), todo: todo)
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
