//
//  TodoItemView.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import SwiftUI

struct TodoItemView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @ObservedObject var todoModel: TodoModel
  @ObservedObject var todo: Todo
  
  var body: some View {
    // ContentViewから渡された変数を受け取る
    
    
    HStack {
      Image(systemName: todo.wrappedState ? "checkmark.circle" : "circle")
        .foregroundColor(todo.wrappedState ? .gray : (determiningPriority(priority: todo.wrappedName) ? .red : .black))
        .onTapGesture {
          toggleState(for: todo)
          do {
            try managedObjectContext.save()
          } catch {
            print(error)
          }
        }
      
      // MARK: - NAVIGATION LINK
//      NavigationLink(destination: TodoDetailView(todoModel: todoModel, todo: todo)) {
        Text(todo.wrappedName)
          .foregroundColor(todo.state ? .gray : (determiningPriority(priority: todo.wrappedPriority) ? .red : .black))
          .strikethrough(todo.state, color: .black)
        
        Spacer()
        
        Text(formatDate(todo.wrappedDadeline))
          .font(.footnote)
          .foregroundColor(todo.wrappedState ? .gray : (determiningPriority(priority: todo.wrappedPriority) ? .red : .black))
          .opacity(0.5)
        
        Text(todo.priority ?? "Unknown")
          .foregroundColor(todo.wrappedState ? .gray : (determiningPriority(priority: todo.wrappedPriority) ? .red : .black))
//      }
      //    } // END: HSTACK
      .padding(.vertical, 8)
    } // END: HSTACK
    .onTapGesture {
      todoModel.editTodo(todo: todo)
    }
  }
    // MARK: - FUNCTIONS
    private func formatDate(_ date: Date?) -> String {
      guard let date = date else { return "" }
      let formatter = DateFormatter()
      formatter.dateFormat = "MM月dd日"
      return formatter.string(from: date)
    }
    
    private func toggleState(for todo: Todo) {
      todo.state.toggle()
      do {
        try managedObjectContext.save()
      } catch {
        print(error)
      }
      //ウィジェットのに対する
      //    do {
      //      try managedObjectContext.save()
      //      // 追加
      //      WidgetCenter.shared.reloadAllTimelines()
      //
      //    } catch {
      //      let nsError = error as NSError
      //      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      //    }
    }
    
    private func determiningPriority (priority: String) -> Bool {
      switch priority {
      case "高":
        return true
      default:
        return false
      }
    }
  }
