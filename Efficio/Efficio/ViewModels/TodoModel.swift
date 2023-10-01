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
  @Published var deadline: Date?
  var id = UUID()
  
  @Published var isNewTodo = false  // 新規作成か編集かを判断する: true -> 新規作成, false -> 編集
  @Published var isEditing: Todo!
  
  // MARK: - WRITE TODO
  func writeTodo(context : NSManagedObjectContext) {
    print("呼び出し - writeTodo")
    print(isEditing ?? "-X-")
    
    // ここで新規作成か編集かを判断する
    if isEditing != nil {  // 編集の場合
      print("- 編集")
      print(isEditing ?? "-X-")
      
      
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
      deadline = nil
      
      return
    } // END: if isEditing != nil : 編集の場合
    

        // 新規作成の場合
    print(name)
    print(priority)
    print(state)
    print(deadline ?? "")
//    resetData()
    
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
      deadline = nil
    } catch {
      print(error.localizedDescription)
    }
  } // END: WRITE TODO
  
  // MARK: - EDIT TODO
  func editTodo(todo: Todo) {  // 編集ボタンを押した時に呼び出される
    print("呼び出し - editTodo")
    isEditing = todo  // 編集対象のTodoを受け取る
    
    print(todo)
    
    name = todo.wrappedName
    priority = todo.wrappedPriority
    deadline = todo.deadline
    state = todo.wrappedState
    id = todo.wrappedId
    
    isNewTodo.toggle()
  }
  
  // MARK: - RESET TODO
  func resetData() {
    print("呼び出し - resetData")
    name = ""
    priority = ""
    state = false
    deadline =  nil
    isEditing = nil
    isNewTodo = false
  }
  
}
