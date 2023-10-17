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
import WidgetKit

class TodoViewModel: ObservableObject {
  //  static let shared = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  // MARK: - PROPERTIES
  
  @Published var name = ""
  @Published var priority = ""
  @Published var state = false
  @Published var deadline_date: Date?
  @Published var deadline_time: Date?

  @Published var id = UUID()
  @Published var order:Int16 = 0
  
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
    request.sortDescriptors = [/*NSSortDescriptor(keyPath: \Todo.name, ascending: true),*/
      NSSortDescriptor(keyPath: \Todo.order, ascending: true)]  // リクエストを実行し、結果をTodo型の配列として取得
    
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
      isEditing.deadline_date = deadline_date
      isEditing.deadline_time = deadline_time
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
      deadline_date = nil
      deadline_time = nil
      order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
      WidgetCenter.shared.reloadAllTimelines()
      return
    } // END: if isEditing != nil : 編集の場合
    
    // MARK: - NEW TODO
    // 新規作成の場合
    print(name)
    print(priority)
    print(state)
    print(deadline_date ?? "")
    print(deadline_time ?? "")
    //    resetData()
    
    let newTodo = Todo(context: context)
    newTodo.name = name
    newTodo.priority = priority
    newTodo.state = state
    newTodo.deadline_date = deadline_date
    newTodo.deadline_time = deadline_time
    newTodo.order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
    newTodo.id = UUID()
    
    do {
      try context.save()
      isNewTodo.toggle()
      
      name = ""
      priority = ""
      state = false
      deadline_date = nil
      deadline_time = nil
      order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
    } catch {
      print("writeTodo(2)でエラー")
      print(error.localizedDescription)
    }
    WidgetCenter.shared.reloadAllTimelines()
  } // END: WRITE TODO
  
  // MARK: - EDIT TODO
  func editTodo(todo: Todo) {  // 編集ボタンを押した時に呼び出される
    print("呼び出し - editTodo")
    isEditing = todo  // 編集対象のTodoを受け取る
    
    print(todo)
    
    name = todo.wrappedName
    priority = todo.wrappedPriority
    deadline_date = todo.deadline_date
    deadline_time = todo.deadline_time
    state = todo.state
    id = todo.wrappedId
    order = todo.order
    
    isNewTodo.toggle()
  }
  
  // MARK: - RESET FORM
  func resetForm() {
    print("呼び出し - resetForm")
    name = ""
    priority = ""
    state = false
    deadline_date =  nil
    deadline_time = nil
    isEditing = nil
    isNewTodo = false
    order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
  }
  
  // MARK: - DELETE TODO
  func toggleTodoState(for todo: Todo) {
    todo.state.toggle()
    do {
      try context.save()
    } catch {
      print("TodoItemView_toggleState: 保存できませんでした")
      print(error)
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  // MARK: - TOGGLE TODO STATE BY ID
  func toggleTodoStateById(forTask id: String) {
    print("呼び出し - toggleState")
    guard let uuid = UUID(uuidString: id) else {
      print("Invalid UUID string: \(id)")
      return
    }
    
    let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
    
    do {
      let matchingTodos = try context.fetch(fetchRequest)
      toggleTodoState(for: matchingTodos.first!)
    } catch {
      print("Error toggling Todo state: \(error)")
    }
  }
  
  // MARK: - DELETE TODO
  func deleteTodo(at offsets: IndexSet) {
    for index in offsets {
      let todo = todos[index]
      context.delete(todo)
      do {
        try context.save()
      } catch {
        context.rollback()
        print("ContentViewでエラー")
        print(error.localizedDescription)
      }
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  // MARK: - DELETE ALL COMPLETED TODO
  func deleteAllCompletedTodo() {
    for todo in todos.filter({ $0.state }){
      print("削除するtodo: \(todo.name!)")
      context.delete(todo)
      do {
        try context.save()
      } catch {
        print("deleteAllCompletedTodoでエラー")
        print(error.localizedDescription)
      }
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  // MARK: - MOVE TODO
  func moveTodo(from source: IndexSet, to destination: Int) {
    var revisedItems: [Todo] = todos.map{$0}
    revisedItems.move(fromOffsets: source, toOffset: destination)
    for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
      revisedItems[reverseIndex].order = Int16(reverseIndex)
    }
    do {
      try context.save()
    } catch {
      print("moveTodoでエラー")
      print(error.localizedDescription)
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  
}

