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
  
  // THEME
  @ObservedObject var theme: ThemeViewModel
  @Environment(\.colorScheme) var colorScheme
  // MARK: - BODY
  
  var body: some View {
    
    
    HStack {
      // MARK: - CHECKMARK
      Image(systemName: todo.state ? "checkmark.circle" : "circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : theme.getTodoItemForegroundColor(for: colorScheme) ? .white : .black))
      // MARK: - CHECKMARK ONTAPGESTURE
        .onTapGesture {
          todoModel.toggleTodoState(for: todo)
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      // MARK: - TODO NAME
      Text(todo.wrappedName)
        .font(.custom("HelveticaNeue", size: 15)).bold()
      
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : theme.getTodoItemForegroundColor(for: colorScheme) ? .white : .black))
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
          } else {
            HStack {
              Image(systemName: "clock")
              Text("00時00分")
            }.hidden()
          }
        }
        //フォントのサイズ変更
        .font(.custom("HelveticaNeue", size: 11))
        .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? .red : theme.getTodoItemForegroundColor(for: colorScheme) ? .white : .black))
        .opacity(0.5)
      }
      // MARK: - PRIORITY
      if todo.priority != 0 {
        Text(priorityText(for: todo.priority))
          .font(.footnote)
          .foregroundColor(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black))
          .opacity(0.5)
          .padding(3)
          .frame(minWidth: 62)
          .overlay(
            Capsule().stroke(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black), lineWidth: 0.75)
              .opacity(0.5)
          )
      } else {
        Text(priorityText(for: todo.priority))
          .font(.footnote)
          .opacity(0.5)
          .padding(3)
          .frame(minWidth: 62)
          .overlay(
            Capsule().stroke(todo.state ? .gray : (priorityJudgment(priority: todo.wrappedPriority) ? Color("priority_high") : .black), lineWidth: 0.75)
              .opacity(0.5)
          )
          .hidden()
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
  private func priorityJudgment (priority: Int16) -> Bool {
    switch priority {
    case 3: // 高
      return true
    default:
      return false
    }
  }
  
  private func priorityText(for priority: Int16) -> String {
    switch priority {
    case 3: return "高"
    case 2: return "中"
    case 1: return "低"
    default: return "なし"
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
//    return TodoItemView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), todo: todo,theme: ThemeViewModel.shared)
//      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}
