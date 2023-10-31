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
        HStack(spacing: geometry.size.width/35) {
          
          VStack(alignment: .leading){
            Text("マイタスク")
              .font(.system(size: 22,weight: .bold,design: .default))
              .foregroundStyle(Color("WidgetBackground"))
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
            .foregroundStyle(Color("WidgetBackground"))
            Spacer()
            Link(destination: URL(string: "addTodo://")!) {
              Circle().fill()
                .foregroundColor(Color("ItoW"))
                .shadow(radius: 2)
                .frame(width:54,height: 55)
                .overlay(
                  Image(systemName: "note.text.badge.plus")
                    .resizable()
                    .foregroundColor(Color("WtoB"))
                    .scaledToFit()
                    .frame(width:42)
                    .offset(x:3,y:1)
                )
            }//: LINK
          }//: VSTACK
          Spacer()
          VStack(alignment: .leading,spacing: 19) {
            if !todos.isEmpty {
              // MARK: - FOREACH
              ForEach(todos.prefix(4), id: \.id) { todo in
                if #available(iOS 17.0, *) {
                  // MARK: - BUTTON
                  Button(intent: TodoToggleIntent(todo:todo.id!.uuidString)) {
                    MediumWidgetTodoItemView(todo: todo)
                  } //: BUTTON
                  .buttonStyle(.plain)
                } else {
                  MediumWidgetTodoItemView(todo: todo)
                }
              } //: FOREACH
            }else {
              Spacer()
              EmptyWidget(point: 17)
            }
          }  //: VSTACK
        }  //: HSTACK
      }

      .widgetBackground(Color("WidgetBackground"))
      .mediumWidgetPaddingSettingsForEachOs()
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

