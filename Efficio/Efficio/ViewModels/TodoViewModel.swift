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
  @Published var priority: Int16 = 0 {
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

  // MARK: - FILTER AND SORT PROPERTIES
  private static let sharedDefaults = UserDefaults(suiteName: "group.hapiharu012.Efficio.app")!

  @Published var isFilterExpanded: Bool = false
  @Published var showCompleted: Bool = {  // 完了済みタスクを表示するか
    if let saved = sharedDefaults.object(forKey: "FilterShowCompleted") as? Bool {
      return saved
    }
    return true  // デフォルトは表示
  }() {
    didSet {
      Self.sharedDefaults.set(showCompleted, forKey: "FilterShowCompleted")
      updateFilteredTodos()
      WidgetCenter.shared.reloadAllTimelines()
    }
  }
  @Published var sortBy: SortCriteria = {  // デフォルトは優先度
    if let savedValue = sharedDefaults.string(forKey: "FilterSortBy"),
       let criteria = SortCriteria(rawValue: savedValue) {
      return criteria
    }
    return .priority
  }() {
    didSet {
      Self.sharedDefaults.set(sortBy.rawValue, forKey: "FilterSortBy")
      updateFilteredTodos()
      WidgetCenter.shared.reloadAllTimelines()
    }
  }
  @Published var sortOrder: SortOrder = {
    if let savedValue = sharedDefaults.string(forKey: "FilterSortOrder"),
       let order = SortOrder(rawValue: savedValue) {
      return order
    }
    return .ascending
  }() {
    didSet {
      Self.sharedDefaults.set(sortOrder.rawValue, forKey: "FilterSortOrder")
      updateFilteredTodos()
      WidgetCenter.shared.reloadAllTimelines()
    }
  }

  // MARK: - GET TODOS
  @Published var todos: [Todo] = [] {
    didSet {
      updateFilteredTodos()
    }
  }
  @Published var filteredTodos: [Todo] = []
  private var context: NSManagedObjectContext
  private var contextDidSaveObserver: Any?
  private var remoteChangeObserver: Any?

  // MARK: - SORT ENUMS
  enum SortCriteria: String, CaseIterable {
    case priority = "優先度"
    case deadline = "期日"
  }

  enum SortOrder: String, CaseIterable {
    case ascending = "昇順"
    case descending = "降順"
  }
  
  
  init(context: NSManagedObjectContext) {
    //    self.context = /*PersistenceController.shared.container.viewContext*/context
    self.context = context
    fetchTodos()
    setupNotificationSubscription()
    updateFilteredTodos()
  }

  deinit {
    if let observer = contextDidSaveObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    if let observer = remoteChangeObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }

  private func setupNotificationSubscription() {// 通知を受け取る
    // 同一プロセス内の変更を監視
    contextDidSaveObserver = NotificationCenter.default.addObserver(
      forName: NSNotification.Name.NSManagedObjectContextDidSave,
      object: nil,
      queue: nil
    ) { [weak self] _ in
      self?.fetchTodos()
    }

    // 異なるプロセス（ウィジェット）からの変更を監視
    remoteChangeObserver = NotificationCenter.default.addObserver(
      forName: .NSPersistentStoreRemoteChange,
      object: nil,
      queue: nil
    ) { [weak self] _ in
      DispatchQueue.main.async {
        guard let self = self else { return }
        // リモートの変更を反映するため、contextをリフレッシュ
        self.context.refreshAllObjects()
        self.fetchTodos()
      }
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

  // MARK: - UPDATE FILTERED TODOS
  private func updateFilteredTodos() {
    var filtered = todos

    // 完了済みタスクのフィルタリング
    if !showCompleted {
      filtered = filtered.filter { !$0.state }
    }

    // ソート処理
    filtered = sortTodos(filtered)

    self.filteredTodos = filtered
  }

  // MARK: - SORT TODOS
  private func sortTodos(_ todos: [Todo]) -> [Todo] {
    switch sortBy {
    case .priority:
      // 優先度でソート（優先度0=未設定は常に最後）
      return todos.sorted { todo1, todo2 in
        let p1 = todo1.priority
        let p2 = todo2.priority

        // 優先度0（未設定）の扱い
        if p1 == 0 && p2 == 0 {
          return todo1.order < todo2.order // 両方未設定の場合はorder順
        } else if p1 == 0 {
          return false // todo1が未設定の場合は後ろ
        } else if p2 == 0 {
          return true // todo2が未設定の場合はtodo1が前
        }

        if sortOrder == .ascending {
          return p1 > p2  // 高い順（3, 2, 1）
        } else {
          return p1 < p2  // 低い順（1, 2, 3）
        }
      }

    case .deadline:
      // 期日でソート（deadline_dateがnilのものは最後）
      return todos.sorted { todo1, todo2 in
        let date1 = todo1.deadline_date
        let date2 = todo2.deadline_date

        if date1 == nil && date2 == nil {
          return todo1.order < todo2.order // 両方nilの場合はorder順
        } else if date1 == nil {
          return false // todo1がnilの場合は後ろ
        } else if date2 == nil {
          return true // todo2がnilの場合はtodo1が前
        } else {
          if sortOrder == .ascending {
            return date1! < date2!
          } else {
            return date1! > date2!
          }
        }
      }
    }
  }
  
  
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
      priority = 0
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
    priority = 0
    state = false
    deadline_date = nil
    deadline_time = nil
    order = todos.max(by: { a, b in a.order < b.order })?.order ?? 0
    //    resetForm()
    WidgetCenter.shared.reloadAllTimelines()
  } // END: WRITE TODO
  
  // MARK: - EDIT TODO
  func editTodo(todo: Todo) {  // 編集ボタンを押した時に呼び出される
    
    isEditing = todo  // 編集対象のTodoを受け取る
    
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
    priority = 0
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
      // 保存後、他のcontextに変更を反映させる
      context.refreshAllObjects()
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
    // filteredTodosから削除対象を取得
    let todosToDelete = offsets.map { filteredTodos[$0] }

    for todo in todosToDelete {
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
    // filteredTodosで移動
    var revisedItems: [Todo] = filteredTodos.map{$0}
    revisedItems.move(fromOffsets: source, toOffset: destination)

    // 移動後のorder値を再計算（filteredTodos内のみ）
    for (index, todo) in revisedItems.enumerated() {
      todo.order = Int16(index)
    }

    // フィルター外のTodoのorder値も調整（filteredTodosに含まれないTodoは最後に配置）
    let filteredTodoIDs = Set(revisedItems.map { $0.wrappedId })
    let nonFilteredTodos = todos.filter { !filteredTodoIDs.contains($0.wrappedId) }
    for (offset, todo) in nonFilteredTodos.enumerated() {
      todo.order = Int16(revisedItems.count + offset)
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

