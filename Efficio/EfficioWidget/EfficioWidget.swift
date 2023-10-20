//
//  EfficioWidget.swift
//  EfficioWidget
//
//  Created by hapiharu012 on 2023/10/01.
//

import WidgetKit
import SwiftUI



/**
 表示データと表示時刻の作成
 */
//  MARK: - PROVIDER
struct Provider: TimelineProvider {
  
  // ウィジェットの初期表示
  
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), emoji: "😀")
  }
  
  // 一時的な（最初の）ビュー＆Widget Galleryのプレビュー
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), emoji: "😀")
    completion(entry)
  }
  
  // 時間と共に変化させる間隔とビュー
  
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


/**
 TimelineEntryの構造を定義
 */
// MARK: - SIMPLE ENTRY
struct SimpleEntry: TimelineEntry {
  let date: Date
  let emoji: String
}


/**
 アクティブのTimelineEntryを反映させるビューを構築
 */
// MARK: - EFFICIO WIDGET ENTRY VIEW
struct EfficioWidgetEntryView : View {
  @Environment(\.widgetFamily) var family
  @FetchRequest(entity: Todo.entity(),
               sortDescriptors: [
                 NSSortDescriptor(keyPath: \Todo.order, ascending: true),
                 NSSortDescriptor(keyPath: \Todo.state, ascending: true)
               ]
  ) var todos:FetchedResults<Todo>
  
  
//  var todos = TodoViewModel(context: PersistenceController.shared.container.viewContext).todos
  
  //MARK: - BODY
  var body: some View {
    //MARK: - SWITCH
    switch family {
    case .systemSmall:
      EfficioWidgetSmallView(todos: Array(todos))
    case .systemMedium:
      EfficioWidgetMediumView(todos: Array(todos))
    case .accessoryCircular:
      EfficioWidgetCircular()
    case .accessoryRectangular:
      EfficioWidgetRectangular(todos: Array(todos))
    default:
      fatalError()
    }
  }
    
}


/**
 Widgetの説明を定義
 */
// MARK: - EFFICIO WIDGET
struct EfficioWidget: Widget {
  let persistenceController = PersistenceController.shared
  let kind: String = "EfficioWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { _ in
      EfficioWidgetEntryView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
    .supportedFamilies(supportedFamilies)
    .configurationDisplayName("Efficio")
    .description("This is a widget where you can see your task list.")
  }
  private var supportedFamilies: [WidgetFamily] {
          if #available(iOSApplicationExtension 16.0, *) {
              return [
                  .systemSmall,
                  .systemMedium,
//                  .systemLarge,
//                  .systemExtraLarge,
                  .accessoryCircular,
                  .accessoryRectangular
              ]
          } else {
              return [
                  .systemSmall,
                  .systemMedium,
                  .systemLarge
              ]
          }
      }
}


/**
 プレビュー用
 */
// MARK: - EFFICIO WIDGET_PREVIEWS
struct EfficioWidget_Previews: PreviewProvider {
  static var previews: some View {
    //        let context = PersistenceController.preview.container.viewContext
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    EfficioWidgetEntryView()
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
