//
//  TodoItemView.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import SwiftUI
import WidgetKit

struct TodoItemView: View {
  // MARK: - PROPERTIES

  @Environment(\.managedObjectContext) var managedObjectContext
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var todo: Todo
  
  
  // MARK: - BODY

  var body: some View {
    HStack {
      Image(systemName: todo.wrappedState ? "checkmark.circle" : "circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(todo.wrappedState ? .gray : (priorityJudgment(priority: todo.wrappedName) ? .red : .black))
        .onTapGesture {
          toggleTodoState(for: todo)
          do {
            try managedObjectContext.save()
              WidgetCenter.shared.reloadAllTimelines()
          } catch {
            print(error)
          }
        }
      
      Text(todo.wrappedName)
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .strikethrough(todo.state, color: .black)
        .offset(x: 10)
      Spacer()
      if todo.deadline != nil{
        HStack {
          Image(systemName: "calendar")
          Text(dateFormatting(todo.deadline))
        }
        .font(.footnote)
        .foregroundColor(todo.wrappedState ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .opacity(0.5)
      }
      Text(todo.priority ?? "")
        .foregroundColor(todo.wrappedState ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : .black))
        .padding(.vertical, 8)
    } // END: HSTACK
    .padding(.vertical, 8)
    
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
  private func toggleTodoState(for todo: Todo) {
    todo.state.toggle()
    do {
      try managedObjectContext.save()
    } catch {
      print(error)
    }
  }
  private func priorityJudgment (priority: String) -> Bool {
    switch priority {
    case "高":
      return true
    default:
      return false
    }
  }
  
}// END: TODOITEMVIEW


// MARK: - PREVIEW

struct TodoItemView_Previews: PreviewProvider {
  static var previews: some View {
    let todo = Todo(context: PersistenceController.preview.container.viewContext)
    todo.name = "サンプルTodo"
    todo.priority = "中"
    todo.state = false
    todo.deadline = Date()
    todo.id = UUID()
    
    return TodoItemView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), todo: todo).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
