//
//  EfficioWidgetMediumView.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/06.
//

import SwiftUI
import WidgetKit

struct EfficioWidgetMediumView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.widgetFamily) var family
  @ObservedObject var todoModel: TodoViewModel
  
    var body: some View {
      HStack {
        VStack(alignment: .leading,spacing: 10){
          Text("マイタスク")
            .font(.system(size: 22,weight: .bold,design: .default))
//              .padding(.bottom)
          HStack {
            //                    Spacer()
            Text(formatDateTitleDay(Date()))
              .font(.system(size: 22))
            //                        .padding(.trailing)
            VStack(alignment: .leading) {
              Text(formatDateTitleDayOfWeek(Date()))
                .font(.system(size: 10))
              Text(String(SameDayNum(todos: todoModel.todos))+"件")
                .font(.system(size: 10))
            }
            //                    Spacer()
            
          } // END: HSTACK

          Link(destination: URL(string: "addTodo://")!) {
            Circle().fill()
              .foregroundColor(.white)
              .shadow(radius: 2)
              .overlay(
                Image(systemName: "note.text.badge.plus")
                  .resizable()
                  .foregroundColor(.blue)
                  .scaledToFit()
                  .frame(width: 40)
                  .position(CGPoint(x: 30.0, y: 28.0))
                )
//                .position(CGPoint(x: 10.0, y: 10.0))
          }
//            .position(CGPoint(x: 10.0, y: 10.0))

        }
//          .position(CGPoint(x: 53.0, y: 45.0))
        
        VStack(spacing: 15) {
          if !todoModel.filteredTodos.isEmpty {
            ForEach(todoModel.filteredTodos, id: \.self) { todo in
              //                if isSameDay(date1: todo.deadline ?? Date(), date2: Date()) {
              HStack {
                
                Image(systemName: todo.state ? "checkmark.circle" : "circle")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 12)
                  .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                  .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                
                
                Group{
                  Text(todo.name ?? "Unknown")
                    .font(.custom("HelveticaNeue", size: 14))
                    .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                  Spacer()
                  
                  Text(formatDate(todo.deadline))
                    .font(.custom("HelveticaNeue", size: 10))
                    .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                    .opacity(0.5)
                  
                  
                  
                  Circle()
                    .frame(width: 7, height: 12, alignment: .center)
                    .foregroundColor(colorize(priority: todo.priority ?? "中"))
                }.foregroundColor(todo.state ? Color.gray : Color.primary)
                  .strikethrough(todo.state)
                
                
              } //END: HSTACK
              
            }// END: FOREACH
          }else {
            EmptyWidget(point: 17)
          }
        }
        
        
      } //END: VSTACK
      .widgetBackground(Color.white)
    }
}

#Preview {
    EfficioWidgetMediumView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext))
}
