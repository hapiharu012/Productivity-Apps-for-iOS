//
//  TodoModel.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import Foundation
import CoreData
import SwiftUI

class TodoModel: ObservableObject {
  @Published var name = ""
  @Published var priority = ""
  @Published var state = false
  @Published var deadline = Date()
  @Published var id = UUID()
  
  
  @Published var isNewTodo = false
  @Published var isEditing: Todo!
  
  func writeTodo(context : NSManagedObjectContext) {
    print("----")
    
    // ここで新規作成か編集かを判断する
    if isEditing != nil {  // 編集の場合
      print("編集")
      
      
      isEditing.name = name
      isEditing.priority = priority
      isEditing.state = state
      isEditing.deadline = deadline
      
      do {
        try context.save()
      } catch {
        print(error)
      }
      
      isEditing = nil
      isNewTodo.toggle()
      
      name = ""
      priority = ""
      state = false
      deadline = Date()
      
      return
    }
      let newTodo = Todo(context: context)
      newTodo.name = name
      newTodo.priority = priority
      newTodo.state = state
      newTodo.deadline = deadline
      newTodo.id = UUID()
      
      do {
        try context.save()
        isNewTodo.toggle()
        
        name = ""
        priority = ""
        state = false
        deadline = Date()
      
        
      } catch {
        print(error.localizedDescription)
      }
    
    
    
    
    
    
  }
  
  func editTodo(todo: Todo) {
    isEditing = todo
    print(todo)
    
    name = todo.wrappedName
    priority = todo.wrappedPriority
    deadline = todo.wrappedDadeline
    state = todo.wrappedState
    id = todo.wrappedId
    
    
    
    isNewTodo = true
  }
  
}
