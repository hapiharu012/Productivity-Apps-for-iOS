//
//  EfficioWidgetMediumView.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import WidgetKit
import CoreData

struct EfficioWidgetMediumView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.widgetFamily) var family
  @State var todos: [Todo]

  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  let calendar = Calendar.current
  
  // MARK: - BODY
    var body: some View {
      
      // MARK: - HSTACK
      HStack {
        
        VStack(alignment: .leading,spacing: 10){
          Text("マイタスク")
            .font(.system(size: 22,weight: .bold,design: .default))
          HStack {
            Text(calendar.formatDateTitleDay(Date()))
              .font(.system(size: 22))
            VStack(alignment: .leading) {
              Text(calendar.formatDateTitleDayOfWeek(Date()))
                .font(.system(size: 10))
              Text(String(calendar.SameDayNum(todos: todos))+"件")
                .font(.system(size: 10))
            }//: VSTACK
            
          } //: HSTACK

          Link(destination: URL(string: "addTodo://")!) {
            Circle().fill()
              .foregroundColor(Color("ItoW"))
              .shadow(radius: 2)
            
              .overlay(
                Image(systemName: "note.text.badge.plus")
                  .resizable()
                  .foregroundColor(Color("WtoB"))
                  .scaledToFit()
                  .frame(width: 40)
                  .position(CGPoint(x: 30.0, y: 28.0))
                )
          }//: LINK

        }//: VSTACK
        
        
        VStack(alignment: .leading,spacing: 15) {
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
                    .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
                    
                    
                    
                    Group{
                      Text(todo.name ?? "Unknown")
                        .font(.custom("HelveticaNeue", size: 14))
                        .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
                      Spacer()
                      
                      Text(calendar.formatDate(todo.deadline_date))
                        .font(.custom("HelveticaNeue", size: 10))
                        .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
                        .opacity(0.5)
                      
                      
                      
                      Circle()
                        .frame(width: 7, height: 12, alignment: .center)
                        .foregroundColor(Utility.colorize(priority: todo.priority ?? "中"))
                    }.foregroundColor(todo.state ? Color.gray : Color.primary)
                      .strikethrough(todo.state)
                    
                    
                  } //: HSTACK

                } //: BUTTON
                .buttonStyle(.plain)
                              
            } //: FOREACH
          }else {
            EmptyWidget(point: 17)
          }
        } //: VSTACK
        
        
      } //: VSTACK
//      .widgetBackground(Color("BtoW"))
      .widgetBackground(Color("WidgetBackground"))

    } //: BODY
} //: VIEW


// MARK: - PREVIEW
struct EfficioWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
      let dummyTodos = Utility.createDummyTodos(context: context)

        
        return EfficioWidgetMediumView(todos: dummyTodos)
            .environment(\.managedObjectContext, context)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

