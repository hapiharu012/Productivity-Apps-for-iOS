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
  
  // todoのプロパティ
  @Published var name = ""
  @Published var priority = "" {
    didSet {
      generateHapticFeedback()
    }
  }
  @Published var state = false
  @Published var deadline_date: Date?
  @Published var deadline_time: Date?
  @Published var id = UUID()
  @Published var order:Int16 = 0
  
  @Published var isNewTodo = false  // 新規作成か編集かを判断する: true -> 新規作成, false -> 編集
  @Published var isEditing: Todo!
  
  @Published var errorShowing1: Bool = false
  @Published var errorShowing2: Bool = false
  
  @Published var errorTitle: String = ""
  @Published var errorMessage = ""
  
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
  
  private func generateHapticFeedback() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
  }
  
  func fetchTodos() {// データを取得する
    let request: NSFetchRequest<Todo> = Todo.fetchRequest() // Todo型のフェッチリクエストを作成
    request.sortDescriptors = [/*NSSortDescriptor(keyPath: \Todo.name, ascending: true),*/
      NSSortDescriptor(keyPath: \Todo.order, ascending: true)]  // リクエストを実行し、結果をTodo型の配列として取得
    
    do {
      self.todos = try context.fetch(request) // フェッチに失敗した場合のエラーハンドリング
    } catch {
      self.errorShowing2 = true
      self.errorTitle = "データの取得に失敗しました"
      self.errorMessage = "再起動してください。"
    }
  }
  // END: GET TODOS
  
  
  // MARK: - WRITE TODO
  func writeTodo(context : NSManagedObjectContext) {
    
    // ここで新規作成か編集かを判断する
    // MARK: - EDITING
    if isEditing != nil {  // 編集の場合
      
      
      isEditing.name = name
      isEditing.priority = priority
      isEditing.state = state
      isEditing.deadline_date = deadline_date
      isEditing.deadline_time = deadline_time
      do {
        try context.save()
      } catch {
        self.errorShowing1 = true
        self.errorTitle = "データの保存に失敗しました."
        self.errorMessage = "再度登録をしてください。"
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
      
      
    } catch {
      self.errorShowing1 = true
      self.errorTitle = "データの保存に失敗しました。"
      self.errorMessage = "再度登録をしてください。"
    }
    name = ""
    priority = ""
    state = false
    deadline_date = nil
    deadline_time = nil
    order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
    //    resetForm()
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
    name = ""
    priority = ""
    state = false
    deadline_date =  nil
    deadline_time = nil
    isEditing = nil
    isNewTodo = false
    order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
  }
  
  // MARK: - TGGLE TODO
  func toggleTodoState(for todo: Todo) {
    todo.state.toggle()
    do {
      try context.save()
    } catch {
      self.errorShowing2 = true
      self.errorTitle = "データの保存に失敗しました。"
      self.errorMessage = "再度操作をしてください。"
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  // MARK: - TOGGLE TODO STATE BY ID
  func toggleTodoStateById(forTask id: String) {
    guard let uuid = UUID(uuidString: id) else {
      return
    }
    
    let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
    
    do {
      let matchingTodos = try context.fetch(fetchRequest)
      toggleTodoState(for: matchingTodos.first!)
    } catch {
      return
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
        self.errorShowing2 = true
        self.errorTitle = "データの削除に失敗しました。"
        self.errorMessage = "再度操作をしてください。"
      }
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  // MARK: - DELETE ALL COMPLETED TODO
  func deleteAllCompletedTodo() {
    for todo in todos.filter({ $0.state }){
      context.delete(todo)
      do {
        try context.save()
      } catch {
        self.errorShowing2 = true
        self.errorTitle = "データの削除に失敗しました。"
        self.errorMessage = "再度操作をしてください。"
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
      self.errorShowing2 = true
      self.errorTitle = "データの移動に失敗しました。"
      
    }
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  
}

