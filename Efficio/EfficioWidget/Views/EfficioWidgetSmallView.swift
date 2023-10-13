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
          ForEach(todos.prefix(4), id: \.id) { todo in
            
              Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
                HStack {
                Image(systemName: todo.state ? "checkmark.circle" : "circle")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 12)
                  .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                  .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                  
                  //              Group{
                                  Text(todo.name ?? "")
                                    .font(.custom("HelveticaNeue", size: 11))
                                    .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                                    .lineLimit(1)
                  //                  .fixedSize(horizontal: true, vertical: false)
                  //                  .background(Color.red)

                  //              }
                              .foregroundColor(todo.state ? Color.gray : Color.primary)
                                  .strikethrough(todo.state)
                                Spacer()
                  //              if (!todo.priority? == "") {
                                  Circle()
                                    .frame(width: 6, height: 12, alignment: .center)
                                    .foregroundColor(colorize(priority: todo.priority ?? "中"))
                  //              }
                              } //END: HSTACK
              }
              .buttonStyle(.plain)
              

            
          } // END: FOREACH
//          .position(CGPoint(x: 43.0, y: 8.0))
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
