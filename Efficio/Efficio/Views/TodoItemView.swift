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
  
  let calendar = Calendar.current
  
  
  // MARK: - BODY
  
  var body: some View {
    @Environment(\.colorScheme) var colorScheme
    
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
        .font(.system(size: 14, weight: priorityJudgment(priority: todo.wrappedName) ? .bold : .medium, design: .none))
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black))
        .strikethrough(todo.state, color: .black)
        .offset(x: 10)
      Spacer()
      // MARK: - DEADLINE
      if todo.deadline_date != nil || todo.deadline_time != nil {
        VStack(alignment: .leading) {
          if todo.deadline_date != nil {
            HStack {
              Image(systemName: "calendar")
              Text(calendar.formatDateAndOptimization(date : todo.deadline_date!))
            }
          }
          if todo.deadline_time != nil{
            HStack {
              Image(systemName: "clock")
              Text(calendar.formatTime(date: todo.deadline_time!))
            }
          }
        }
        //フォントのサイズ変更
        .font(.system(size: 10, weight: .medium, design: .none))
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .opacity(0.5)
      }
      // MARK: - PRIORITY
      if todo.priority != "" {
        Text(todo.priority ?? "")
          .font(.footnote)
          .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black))
          .opacity(0.5)
          .padding(3)
          .frame(minWidth: 62)
          .overlay(
            Capsule().stroke(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black), lineWidth: 0.75)
              .opacity(0.5)
          )
      }
    } //: HSTACK
    .background(.clear)
    
    // MARK: - ONTAPGESTURE
    .onTapGesture {
      // 編集画面のsheetが出るようにする
      todoModel.editTodo(todo: todo)
    }
  }// END: BODY
  
  // MARK: - FUNCTIONS
  
  
// MARK: - PRIORITY JUDGMENT
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

//struct TodoItemView_Previews: PreviewProvider {
//  static var previews: some View {
//    let todo = Todo(context: PersistenceController.preview.container.viewContext)
//    todo.name = "サンプルTodo"
//    todo.priority = "中"
//    todo.state = false
//    todo.deadline_date = Date()
//    todo.deadline_time = Date()
//    todo.id = UUID()
//
////    todo.name = "サンプルTodo"
////    todo.priority = ""
////    todo.state = false
////    todo.deadline = nil
////    todo.id = UUID()
//
////    return TodoItemView(todoModel: TodoViewModel(), todo: todo)
//    return TodoItemView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), todo: todo)
//      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}
