//
//  SmallWidgetTodoItemView.swift
//  EfficioWidgetExtension
//
//  Created by hapiharu012 on 2023/10/30.
//

import SwiftUI

struct SmallWidgetTodoItemView: View {
  @ObservedObject var todo: Todo
  var body: some View {
    HStack {
      Image(systemName: todo.state ? "checkmark.circle" : "circle")
        .resizable()
        .scaledToFit()
        .frame(width: 12)
        .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
      
      Text(todo.name ?? "")
        .font(.custom("HelveticaNeue", size: 12))
        .foregroundColor(Utility.determiningPriority(priority: todo.priority!) ? Color("priority_high") : Color("WidgetBackground"))
        .lineLimit(1)
        .foregroundColor(todo.state ? Color.gray : Color.primary)
        .strikethrough(todo.state)
      
      Spacer()
      
      Circle()
        .frame(width: 6, height: 12, alignment: .center)
        .foregroundColor(Utility.colorize(priority: todo.priority ?? ""))
    } //: HSTACK
  } //: BODY
} //: TODO ITEM VIEW
