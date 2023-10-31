//
//  MediumWidgetTodoItemView.swift
//  EfficioWidgetExtension
//
//  Created by hapiharu012 on 2023/10/30.
//

import SwiftUI

struct MediumWidgetTodoItemView: View {
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

