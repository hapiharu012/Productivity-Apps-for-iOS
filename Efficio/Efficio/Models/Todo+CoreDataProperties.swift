//
//  Todo+CoreDataProperties.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/09/26.
//
//

import Foundation
import CoreData
import AppIntents


extension Todo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
    return NSFetchRequest<Todo>(entityName: "Todo")
  }
  
  @NSManaged public var deadline_date: Date?
  @NSManaged public var deadline_time: Date?
  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var priority: Int16
  @NSManaged public var state: Bool
  @NSManaged public var order: Int16
  
}
//毎回nilの場合の処理を考えるのが面倒なのだから設定
extension Todo{
//  public var wrappedDadeline: Date {deadline ?? Date()}
  public var wrappedId: UUID {id ?? UUID()}
  public var wrappedName: String {name ?? ""}
  public var wrappedPriority: Int16 {priority}
}

extension Todo : Identifiable {
  
}

//extension Todo: _IntentValue {
//    // 必要なメソッドやプロパティを実装する
//}
