//
//  TodoItemView.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import SwiftUI

struct TodoItemView: View {
  @ObservedObject var todo: Todo
  @Environment(\.managedObjectContext) var managedObjectContext
  var body: some View {
    // ContentViewから渡された変数を受け取る
    
    
    HStack {
      Image(systemName: todo.state ? "checkmark.circle" : "circle")
        .foregroundColor(todo.state ? .gray : (determiningPriority(priority: todo.priority!) ? .red : .black))
        .onTapGesture {
          toggleState(for: todo)
          do {
            try managedObjectContext.save()
          } catch {
            print(error)
          }
        }
      NavigationLink(destination: TodoDetailView(todo: todo)) {
        Text(todo.name ?? "Unknown")
          .foregroundColor(todo.state ? .gray : (determiningPriority(priority: todo.priority!) ? .red : .black))
          .strikethrough(todo.state, color: .black)
        
        Spacer()
        
        Text(formatDate(todo.deadline))
          .font(.footnote)
          .foregroundColor(todo.state ? .gray : (determiningPriority(priority: todo.priority!) ? .red : .black))
          .opacity(0.5)
        
        Text(todo.priority ?? "Unknown")
          .foregroundColor(todo.state ? .gray : (determiningPriority(priority: todo.priority!) ? .red : .black))
      }
      //    } // END: HSTACK
      .padding(.vertical, 8)
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
