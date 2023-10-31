//
//  EfficioWidgetSmallView.swift
//  Efficio
//
//  Created by hapuharu012 on 2023/10/06.
//

import SwiftUI
import CoreData
import WidgetKit

struct EfficioWidgetSmallView: View {
  @Environment(\.widgetFamily) var family
  @State var todos: [Todo]
  
  
  var body: some View {
    VStack(alignment: .leading){
      Text("マイタスク")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundStyle(Color("WidgetBackground"))
      
      if !todos.isEmpty {
        // MARK: - FOREACH
        Spacer()
        ForEach(todos.prefix(4), id: \.id) { todo in
          
          if #available(iOS 17.0, *) {
            // MARK: - BUTTON
            Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
              SmallWidgetTodoItemView(todo: todo)
            }//: BUTTON
            .buttonStyle(.plain)
            .padding(.vertical, 2)
            
          }else {
            SmallWidgetTodoItemView(todo: todo)
          }
        } //: FOREACH
      }else {
        EmptyWidget(point: 13)
          .position(CGPoint(x: 56, y: 50))
      }
    } //: VSTACK
    .smallWidgetPaddingSettingsForEachOs()
    .widgetBackground(Color("WidgetBackground"))
  } //: BODY
  
  
} //: VIEW


//
//
//struct EfficioWidgetSmallView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        let dummyTodos = createDummyTodos(context: context)
//
//
//        return EfficioWidgetSmallView(todos: dummyTodo)
//            .environment(\.managedObjectContext, context)
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
