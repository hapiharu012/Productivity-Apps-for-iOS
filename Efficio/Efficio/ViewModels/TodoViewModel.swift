//
//  TodoModel.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/09/25.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class TodoViewModel: ObservableObject {
//  static let shared = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  // MARK: - PROPERTIES
  
  @Published var name = ""
  @Published var priority = ""
  @Published var state = false
  @Published var deadline: Date?
  var id = UUID()
  
  @Published var isNewTodo = false  // 新規作成か編集かを判断する: true -> 新規作成, false -> 編集
  @Published var isEditing: Todo!
  

  
  // MARK: - GET TODOS
  @Published var todos: [Todo] = []
  private var context: NSManagedObjectContext
  private var notificationSubscription: Any?
  
 
  init(context: NSManagedObjectContext) {
//    self.context = /*PersistenceController.shared.container.viewContext*/context
    self.context = context
    fetchTodos()
    setupNotificationSubscription()
  }
  
  deinit {
    if let subscription = notificationSubscription {
      NotificationCenter.default.removeObserver(subscription)
    }
  }
  
  private func setupNotificationSubscription() {// 通知を受け取る
    notificationSubscription = NotificationCenter.default.addObserver(
      forName: NSNotification.Name.NSManagedObjectContextDidSave,
      object: nil,
      queue: nil
    ) { [weak self] _ in
      self?.fetchTodos()
    }
  }
  
  func fetchTodos() {// データを取得する
    let request: NSFetchRequest<Todo> = Todo.fetchRequest() // Todo型のフェッチリクエストを作成
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]  // リクエストを実行し、結果をTodo型の配列として取得
    
    do {
      self.todos = try context.fetch(request) // フェッチに失敗した場合のエラーハンドリング
    } catch {
      // handle error
      print("Failed to fetch todos: \(error)")
    }
  }
  // END: GET TODOS
  
  
  // MARK: - WRITE TODO
  func writeTodo(context : NSManagedObjectContext) {
    print("呼び出し - writeTodo")
    print(isEditing ?? "-X-")
    
    // ここで新規作成か編集かを判断する
    // MARK: - EDITING
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
        print("writeTodo(1)でエラー")
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
    
    // MARK: - NEW TODO
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
      print("writeTodo(2)でエラー")
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
  
  // MARK: - TOGGLE TODO STATE BY ID
  func toggleState(forTask id: String) {
    print("呼び出し - toggleState")
      guard let uuid = UUID(uuidString: id) else {
          print("Invalid UUID string: \(id)")
          return
      }
      
      let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
      
      do {
          let matchingTodos = try context.fetch(fetchRequest)
          
          if let matchingTodo = matchingTodos.first {
              matchingTodo.state.toggle()
              print("Toggled Todo state to: \(matchingTodo.state)")
              
              try context.save()
              fetchTodos()
          } else {
              print("No Todo found with ID: \(id)")
          }
      } catch {
          print("Error toggling Todo state: \(error)")
      }
  }

  
}

