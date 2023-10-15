//
//  EfficioWidgetSmallView.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import CoreData
import WidgetKit

struct EfficioWidgetSmallView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.widgetFamily) var family
  @State var todos: [Todo]
  
  
  var body: some View {
    VStack(alignment: .leading){
      Text("マイタスク")
        .font(.headline)
        .fontWeight(.bold)
        .position(CGPoint(x: 38, y: 5))
      
      if !todos.isEmpty {
        // MARK: - FOREACH
        ForEach(todos.prefix(4), id: \.id) { todo in
          
          // MARK: - BUTTON
          Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
            HStack {
              Image(systemName: todo.state ? "checkmark.circle" : "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
              
              Text(todo.name ?? "")
                .font(.custom("HelveticaNeue", size: 13))
                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                .lineLimit(1)
                .foregroundColor(todo.state ? Color.gray : Color.primary)
                .strikethrough(todo.state)
              
              Spacer()
              
              Circle()
                .frame(width: 6, height: 12, alignment: .center)
                .foregroundColor(colorize(priority: todo.priority ?? ""))
            } //: HSTACK
          }//: BUTTON
          .buttonStyle(.plain)
          .padding(.vertical, 2)
          
          
        } //: FOREACH
      }else {
        EmptyWidget(point: 13)
          .position(CGPoint(x: 56, y: 50))
      }
    }//END: VSTACK
    .widgetBackground(Color.white)
  }
  
  
}


//struct EfficioWidgetSmallView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        let dummyTodos = createDummyTodos(context: context)
//
//
//        return EfficioWidgetSmallView(todos: dummyTodos)
//            .environment(\.managedObjectContext, context)
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
