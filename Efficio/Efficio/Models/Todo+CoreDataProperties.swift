//
//  Todo+CoreDataProperties.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/09/26.
//
//

import Foundation
import CoreData


extension Todo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
    return NSFetchRequest<Todo>(entityName: "Todo")
  }
  
  @NSManaged public var deadline: Date?
  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var priority: String?
  @NSManaged public var state: Bool
  
}
//毎回nilの場合の処理を考えるのが面倒なのだから設定
extension Todo{
//  public var wrappedDadeline: Date {deadline ?? Date()}
  public var wrappedId: UUID {id ?? UUID()}
  public var wrappedName: String {name ?? ""}
  public var wrappedPriority: String {priority ?? "中"}
  public var wrappedState: Bool {state }

}

extension Todo : Identifiable {
  
}
