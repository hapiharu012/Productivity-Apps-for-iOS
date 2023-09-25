//
//  TodoListView.swift
//  ToDo-List
//
//  Created by 2023_intern05 on 2023/09/12.
//


import SwiftUI
import CoreData
import WidgetKit

struct ContentView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Todo.name, ascending: true)
                  ]
    ) var todos:FetchedResults<Todo>
    /*
     @FetchRequest:データベースの検索結果とViewを同期する為の大変便利な仕組みであるプロパティラッパー
     entity:          検索対象entityを"エンティティ名.entity()"で指定します。
     sortDescriptors: 検索結果のソート順をNSSortDescriptorの配列で指定します。
     ソート順の指定を省略するには空の配列を渡す
     検索結果のソート順は、NSSortDescriptorクラスを使用して指定します。
     引数keyPathで並べ替える属性を、引数ascendingで昇順（true）か降順（false）を指定します。
     */
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                List{
                    ForEach(self.todos, id: \.self) { todo in
                      TodoItemView(todo: todo)
                    }// END: FOREACH
                    .onDelete(perform: deleteTodo)
                }// END: LIST
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing:
                        Button(action: {
                            showingAddTodoView.toggle()
                        }) {
                            Image(systemName: "pencil.and.outline")
                                .padding()
                        } // END: ADD BUTTON
                    
                )
                if todos.count == 0 {
                    EmptyView()
                }
            }  // END: ZSTACK
                .sheet(isPresented: $showingAddTodoView) {
                    AddTodoView().environment(\.managedObjectContext, managedObjectContext)
                }
                .overlay(
                  ZStack {
                    Group {
                      Circle()
                            .fill(LinearGradient(
                                colors: [
                                  .blue,
                                  .green
                                ],
                                startPoint: animatingButton ? .topLeading : .bottomLeading,
                                endPoint: animatingButton ? .bottomTrailing : .topTrailing
                              ))
                        .opacity(self.animatingButton ? 0.2 : 0)
                        .scaleEffect(self.animatingButton ? 1 : 0)
                        .frame(width: 68, height: 68, alignment: .center)
                      Circle()
                            .fill(LinearGradient(
                                colors: [
                                  .blue,
                                  .green
                                ],
                                startPoint: animatingButton ? .topLeading : .bottomLeading,
                                endPoint: animatingButton ? .bottomTrailing : .topTrailing
                              ))
                        .opacity(self.animatingButton ? 0.15 : 0)
                        .scaleEffect(self.animatingButton ? 1 : 0)
                        .frame(width: 88, height: 88, alignment: .center)
                    }
//                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                      Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .background(Circle().fill(.white))
                        .frame(width: 48, height: 48, alignment: .center)
                
                        
                    } //: BUTTON
                    .accentColor(.blue)
                      .onAppear(perform: {
                         self.animatingButton.toggle()
                      })
                  } //: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                    , alignment: .bottomTrailing
            ) //: OVERLAY
        }  // END: NAVIGATION

    } // END: BODY
    
    
    
    // MARK: - FUNCTIONS
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            do {
                try managedObjectContext.save()
                // 追加
                WidgetCenter.shared.reloadAllTimelines()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
    }
}
