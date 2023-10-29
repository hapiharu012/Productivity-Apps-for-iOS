//
//  EfficioWidgetMediumView.swift
//  Efficio
//
//  Created by hapiharu012 on 2023/10/06.
//

import SwiftUI
import WidgetKit
import CoreData

let calendar = Calendar.current

struct EfficioWidgetMediumView: View {
  @Environment(\.widgetFamily) var family
  @State var todos: [Todo]
  
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  
  
  // MARK: - BODY
  
  var body: some View {
    
    // MARK: - HSTACK
    GeometryReader { geometry in
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
                .font(.system(size: 8))
            }//: VSTACK
            
          } //: HSTACK
//          GeometryReader { geometry in
            Link(destination: URL(string: "addTodo://")!) {
              
              Circle().fill()
                .foregroundColor(Color("ItoW"))
                .shadow(radius: 2)
//                .frame(width: geometry.size.width/5)
                .frame(width:54,height: 55)
                .overlay(
                  Image(systemName: "note.text.badge.plus")
                    .resizable()
                    .foregroundColor(Color("WtoB"))
                    .scaledToFit()
                    .frame(width:42)
                    .offset(x:3,y:1)
                    
//                    .padding(geometry.size.width / 27)
//                    .offset(x: geometry.size.width / 47, y: geometry.size.height / 37)
                  
                )
              
//                .position(CGPoint(x: geometry.size.width / 9.0, y: geometry.size.height / 3.0))
            }//: LINK
//            .frame(width: geometry.size.width/0.3 ,height: geometry.size.height/1)
            
            //            .position(CGPoint(x: geometry.size.width / 2.3, y: geometry.size.height / 2.8))
//          }: GEOMETRY READER
        }//: VSTACK
//              Spacer()
        VStack(alignment: .leading,spacing: 19) {
          if !todos.isEmpty {
            
            // MARK: - FOREACH
            ForEach(todos.prefix(4), id: \.id) { todo in
              if #available(iOS 17.0, *) {
                // MARK: - BUTTON
                Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
                  TodoItemViewForMediumWidget(todo: todo)
                } //: BUTTON
                .buttonStyle(.plain)
              } else {
                TodoItemViewForMediumWidget(todo: todo)
              }
            } //: FOREACH
          }else {
            Spacer()
            EmptyWidget(point: 17)
          }
        }  //: VSTACK
        //      .offset(x: -20)
        .frame(width: (geometry.size.width/10)*6, alignment: .trailing)
        .position(x: (geometry.size.width/11)*4, y: (geometry.size.height/8)*4)
        
        
      }  //: HSTACK
//      .background(Color.red)
    }
    
    //      .widgetBackground(Color("BtoW"))
    .widgetBackground(Color("WidgetBackground"))
    .paddingSettingsForEachOs()
  } //: BODY
} //: VIEW

// MARK: - TODO ITEM VIEW
struct TodoItemViewForMediumWidget: View {
  @ObservedObject var todo: Todo
  var body: some View {
    HStack {
      Image(systemName: todo.state ? "checkmark.circle" : "circle")
        .resizable()
        .scaledToFit()
        .frame(width: 12)
        .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
      
      Group{
        Text(todo.name ?? "Unknown")
          .font(.custom("HelveticaNeue", size: 12))
          .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
          .lineLimit(1)
        Spacer()
        Text(calendar.formatDate(todo.deadline_date))
          .font(.custom("HelveticaNeue", size: 10))
                            .lineLimit(1)
          .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
          .opacity(0.5)
        
        Circle()
          .frame(width: 7, height: 12, alignment: .center)
          .foregroundColor(Utility.colorize(priority: todo.priority ?? "中"))
      }.foregroundColor(todo.state ? Color.gray : Color.primary)
        .strikethrough(todo.state)
    } //: HSTACK
  } //: BODY
} //: TODO ITEM VIEW


// MARK: - PADDING SETTINGS FOR EACH OS
private extension View {
  @ViewBuilder
  func paddingSettingsForEachOs() -> some View {
    if #available(iOS 17.0, *) {
      self.padding(.horizontal,-2)
    } else {
      self.padding(.horizontal,15)
    }
  }
}

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

