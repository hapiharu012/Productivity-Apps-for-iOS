//
//  EfficioWidget.swift
//  EfficioWidget
//
//  Created by k21123kk on 2023/10/01.
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
  var body: some View {
    if family == .systemSmall {
      VStack {
        Text("マイタスク")
          .font(.headline)
          .fontWeight(.bold)
        //                        .padding(.top)
          .position(x:50,y:10)
        HStack {
          Spacer()
          Text(formatDateTitleDay(Date()))
            .font(.system(size: 23))
            .padding(.trailing)
          VStack(alignment: .leading) {
            Text(formatDateTitleDayOfWeek(Date()))
              .font(.system(size: 10))
            Text(String(SameDayNum(todos: todoModel.todos))+"件")
              .font(.system(size: 10))
          }
          Spacer()
          
        } // END: HSTACK
        
        Spacer()
        
        ForEach(filteredTodos, id: \.self) { todo in
          //                if isSameDay(date1: todo.deadline ?? Date(), date2: Date()) {
          HStack {
            
            Image(systemName: todo.state ? "checkmark.circle" : "circle")
              .resizable()
              .scaledToFit()
              .frame(width: 10)
              .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
            
            Group{
              Text(todo.name ?? "Unknown")
                .font(.custom("HelveticaNeue", size: 10))
                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
              Spacer()
              //                            Text(formatDate(todos[index].deadline))
              //                                .font(.custom("HelveticaNeue", size: 8))
              //                                .foregroundColor(.gray)
              
              
              Text(todo.priority ?? "Unknown")
                .font(.custom("HelveticaNeue", size: 8))
                .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
            }.foregroundColor(todo.state ? Color.gray : Color.primary)
              .strikethrough(todo.state)
            
            
          } //END: HSTACK
          
          
          //                }
        } // END: FOREACH
        
        
      } //END: VSTACK
      .padding()
    }
    else if family == .systemMedium {
        HStack {
            VStack(alignment: .leading){
                Text("マイタスク")
                    .font(.system(size: 24,weight: .bold,design: .default))
                    .padding(.bottom)
                HStack {
                    //                    Spacer()
                    Text(formatDateTitleDay(Date()))
                        .font(.system(size: 24))
                    //                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(formatDateTitleDayOfWeek(Date()))
                            .font(.system(size: 11))
                      Text(String(SameDayNum(todos: todoModel.todos))+"件")
                            .font(.system(size: 11))
                    }
                    //                    Spacer()
                    
                } // END: HSTACK
            }
            //                Spacer()
            
            VStack {
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
                                    
                                
                                
                                Text(todo.priority ?? "Unknown")
                                    .font(.custom("HelveticaNeue", size: 12))
                                    .foregroundColor(determiningPriority(priority: todo.priority!) ? .red : .black)
                            }.foregroundColor(todo.state ? Color.gray : Color.primary)
                                .strikethrough(todo.state)
                            
                            
                        } //END: HSTACK
                    
                }
            } // END: FOREACH
            
            
        } //END: VSTACK
        .padding(.horizontal)
        .widgetBackground(Color.white)
    }
  }
  func toggleState(for todo: Todo) {
    todo.state.toggle()
    do {
      try viewContext.save()
    } catch {
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
    
    formatter.dateFormat = "dd日"
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
}

struct EfficioWidget: Widget {
  let persistenceController = PersistenceController.shared
  let kind: String = "EfficioWidget"
  
  var body: some WidgetConfiguration {
         StaticConfiguration(kind: kind, provider: Provider()) { _ in
             EfficioWidgetEntryView()
             .environment(\.managedObjectContext, persistenceController.container.viewContext)
         }
         .configurationDisplayName("My Widget")
         .description("This is an example widget.")
     }
}


struct EfficioWidget_Previews: PreviewProvider {
    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
        return EfficioWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

//#Preview(as: .systemSmall) {
//  EfficioWidget()
//} timeline: {
//  SimpleEntry(date: .now, emoji: "😀")
//  SimpleEntry(date: .now, emoji: "🤩")
//}

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
