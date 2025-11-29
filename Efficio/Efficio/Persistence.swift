//
//  Persistence.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/24.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    //        for index in 0..<10 {
    //            let newItem = Todo(context: viewContext)
    //            newItem.deadline = Date()
    //            newItem.name = "NewTodo-" + String(index+1)
    //            newItem.priority = "中"
    //            newItem.state = false
    //        }
    //変更部分
    let newTodo = Todo(context: viewContext)
    newTodo.id = UUID()
    newTodo.name = "NewTodo"
    newTodo.priority = 1
    newTodo.state = false
    newTodo.deadline_date = Date()
    newTodo.deadline_time = Date()
    
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("-Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {

    //変更部分
    let appGroupId = "group.hapiharu012.Efficio.app"
            guard let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
                fatalError("Failure to init store URL for AppGroup ID: \(appGroupId)")
            }
            let storeUrl = containerUrl.appendingPathComponent("CoreDataWidgetFirst")

            let description = NSPersistentStoreDescription(url: storeUrl)
            // Remote Change Notificationを有効化（ウィジェットとアプリ間でのデータ同期のため）
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

            container = NSPersistentContainer(name: "Efficio")
            container.persistentStoreDescriptions = [description]
    //変更部分ここまで


//    container = NSPersistentContainer(name: "Efficio")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    } else {
      // データベースバージョン管理
      // 現在のアプリバージョンに対応するDBバージョン
      let currentDBVersion = "2.0.0"
      let storedDBVersion = UserDefaults.standard.string(forKey: "DatabaseVersion")

      // バージョンが異なる場合、古いDBを削除
      if storedDBVersion != currentDBVersion {
        print("Database version mismatch. Current: \(currentDBVersion), Stored: \(storedDBVersion ?? "none")")

        if let storeURL = description.url {
          // 既存のストアファイルを削除
          Self.removeStoreFiles(at: storeURL)
          print("Removed old database files")
        }

        // 新しいバージョンを保存
        UserDefaults.standard.set(currentDBVersion, forKey: "DatabaseVersion")
        print("Updated database version to \(currentDBVersion)")
      }
    }

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        print("Core Data error: \(error), \(error.userInfo)")

        // マイグレーションエラーの場合、ストアを削除して再起動を促す
        if error.code == 134140 {
          if let storeURL = storeDescription.url {
            Self.removeStoreFiles(at: storeURL)
            print("Removed incompatible database due to migration error. Please restart the app.")
          }
        }

        fatalError("-Unresolved error \(error), \(error.userInfo)")
      }
    })

    // ViewContextの設定
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    // Transaction Authorを設定（プロセス間でのデータ同期のため）
    container.viewContext.transactionAuthor = "app"
  }

  // MARK: - Helper Methods

  /// データベースファイルとその関連ファイルを削除
  private static func removeStoreFiles(at storeURL: URL) {
    let fileManager = FileManager.default

    // メインのストアファイル
    try? fileManager.removeItem(at: storeURL)

    // WAL (Write-Ahead Logging) ファイル
    let walURL = storeURL.deletingPathExtension().appendingPathExtension("sqlite-wal")
    try? fileManager.removeItem(at: walURL)

    // SHM (Shared Memory) ファイル
    let shmURL = storeURL.deletingPathExtension().appendingPathExtension("sqlite-shm")
    try? fileManager.removeItem(at: shmURL)
  }
}
