//
//  EfficioWidget.swift
//  EfficioWidget
//
//  Created by hapiharu012 on 2023/10/01.
//

import WidgetKit
import SwiftUI
import AppIntents


struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), emoji: "😀")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), emoji: "😀")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, emoji: "😀")
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let emoji: String
}

struct EfficioWidgetEntryView : View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.widgetFamily) var family
  @StateObject private var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  //  @FetchRequest( sortDescriptors: [
  //    NSSortDescriptor(keyPath: \Todo.state, ascending: true),
  //  ],animation: .default) private var todos: FetchedResults<Todo>
  
  var filteredTodos: [Todo] {
    print("filter")
    var count = 0
    var result: [Todo] = []
    
    for todo in todoModel.todos {
      //            if isSameDay(date1: todo.deadline ?? Date(), date2: Date()) {
      if count >= 4 {
        break
      }
      result.append(todo)
      count += 1
      //            }
    }
    
    return result
  }
  
  //MARK: - BODY
  var body: some View {
    //MARK: - SMALL
    if family == .systemSmall {
      VStack(alignment: .leading){
          Text("マイタスク")
            .font(.headline)
            .fontWeight(.bold)
            .position(CGPoint(x: 38, y: 5))
        
        if !filteredTodos.isEmpty {
          ForEach(filteredTodos, id: \.self) { todo in
            HStack {
              
              Image(systemName: todo.state ? "checkmark.circle" : "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
//                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
              
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
                  .foregroundColor(self.colorize(priority: todo.priority ?? "中"))
//              }
            } //END: HSTACK
            
          } // END: FOREACH
//          .position(CGPoint(x: 43.0, y: 8.0))
        }else {
          EmptyWidget(point: 13)
            .position(CGPoint(x: 56, y: 50))
        }
      }//END: VSTACK
          .widgetBackground(Color.white)
      }
    //MARK: - MEDIUM
      else if family == .systemMedium {
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
            if !filteredTodos.isEmpty {
              ForEach(filteredTodos, id: \.self) { todo in
                //                if isSameDay(date1: todo.deadline ?? Date(), date2: Date()) {
                HStack {
                  
                  Image(systemName: todo.state ? "checkmark.circle" : "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12)
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
                      .foregroundColor(self.colorize(priority: todo.priority ?? "中"))
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
    func toggleState(for todo: Todo) {
      todo.state.toggle()
      do {
        try viewContext.save()
      } catch {
        print("togglrstate - " )
        print(error)
        
      }
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
      let calendar = SwiftUI.Calendar.current
      return calendar.isDate(date1, inSameDayAs: date2)
    }
    private func SameDayNum(todos: [Todo]) -> Int {
      let calendar = SwiftUI.Calendar.current
      var count = 0
      for todo in todos { // ForEachの代わりに通常のforループを使用
        if calendar.isDate(todo.deadline ?? Date(), inSameDayAs: Date()) {
          count += 1
        }
      }
      return count
    }
    private func formatDateTitleDayOfWeek(_ date: Date?) -> String {
      guard let date = date else { return "" }
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ja_JP")
      formatter.dateFormat = "EE曜日"
      return formatter.string(from: date)
    }
    private func formatDateTitleDay(_ date: Date?) -> String {
      guard let date = date else { return "" }
      let formatter = DateFormatter()
      
      formatter.dateFormat = "d日"
      return formatter.string(from: date)
    }
    private func formatDate(_ date: Date?) -> String {
      guard let date = date else { return "" }
      let formatter = DateFormatter()
      formatter.dateFormat = "MM月dd日"
      return formatter.string(from: date)
    }
    private func determiningPriority (priority: String) -> Bool {
      switch priority {
      case "高":
        return true
      default:
        return false
      }
    }
  private func colorize(priority: String) -> Color {
    switch priority {
    case "高":
      return .pink
    case "中":
      return .green
    case "低":
      return .blue
    default:
      return .clear
    }
  }
  }
  
  struct EfficioWidget: Widget {
    let persistenceController = PersistenceController.shared
    let kind: String = "EfficioWidget"
    
    var body: some WidgetConfiguration {
      StaticConfiguration(kind: kind, provider: Provider()) { _ in
        EfficioWidgetEntryView()
          .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
      .supportedFamilies([.systemSmall, .systemMedium])
      .configurationDisplayName("My Widget")
      .description("This is an example widget.")
    }
  }
  
  
  struct EfficioWidget_Previews: PreviewProvider {
    static var previews: some View {
      //        let context = PersistenceController.preview.container.viewContext
      EfficioWidgetEntryView()
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      EfficioWidgetEntryView()
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
  }
  
//  #Preview(as: .systemSmall) {
//    EfficioWidget()
//  } timeline: <#@MainActor () async -> [TimelineEntry]#>
  
  extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
      if #available(iOSApplicationExtension 17.0, *) {
        return containerBackground(for: .widget) {
          backgroundView
        }
      } else {
        return background(backgroundView)
      }
    }
  }
