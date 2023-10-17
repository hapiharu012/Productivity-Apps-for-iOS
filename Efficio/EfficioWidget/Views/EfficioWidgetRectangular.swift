//
//  EfficioWidgetRectangular.swift
//  EfficioWidgetExtension
//
//  Created by hapiharu012 on 2023/10/16.
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
              .foregroundColor(Color("BtoW"))
            
            Text(todo.name ?? "")
              .font(.custom("HelveticaNeue", size: 15))
              .foregroundColor(Color("BtoW"))
              .lineLimit(1)
              .foregroundColor(todo.state ? Color.gray : Color.primary)
              .strikethrough(todo.state)
            
            Spacer()
            
            
          } //: HSTACK
        }//: BUTTON
        .buttonStyle(.plain)
        .padding(.vertical, 2)
        .widgetBackground(Color("BtoW"))
        
      } //: FOREACH
    }else {
      EmptyWidget(point: 13)
        .position(CGPoint(x: 56, y: 50))
        .widgetBackground(Color.white)
    }
    
  } //: BODY
  
} //: VIEW

// MARK: - PREVIEW
struct EfficioWidgetRectangular_Previews: PreviewProvider {
  static var previews: some View {
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
