//
//  EfficioWidgetRectangular.swift
//  EfficioWidgetExtension
//
//  Created by k21123kk on 2023/10/16.
//

import SwiftUI
import WidgetKit

struct EfficioWidgetRectangular: View {
  @Environment(\.widgetFamily) var family
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(entity: Todo.entity(),
                sortDescriptors: [
                  NSSortDescriptor(keyPath: \Todo.state, ascending: true),
                  NSSortDescriptor(keyPath: \Todo.name, ascending: true)
                ]
  ) var todos:FetchedResults<Todo>
  
//  @State var todos: [Todo]
  
  var body: some View {
    
    if !todos.isEmpty {
      // MARK: - FOREACH
      ForEach(todos.prefix(2), id: \.id) { todo in
        
        // MARK: - BUTTON
        Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
          HStack {
            Image(systemName: todo.state ? "checkmark.circle" : "circle")
              .resizable()
              .scaledToFit()
              .frame(width: 14)
              .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
              .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
            
            Text(todo.name ?? "")
              .font(.custom("HelveticaNeue", size: 15))
              .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
              .lineLimit(1)
              .foregroundColor(todo.state ? Color.gray : Color.primary)
              .strikethrough(todo.state)
            
            Spacer()
            
            
          } //: HSTACK
        }//: BUTTON
        .buttonStyle(.plain)
        .padding(.vertical, 2)
        .widgetBackground(Color.white)
        
      } //: FOREACH
    }else {
      EmptyWidget(point: 13)
        .position(CGPoint(x: 56, y: 50))
        .widgetBackground(Color.white)
    }
      
  }
    
}

struct EfficioWidgetRectangular_Previews: PreviewProvider {
  static var previews: some View {
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
