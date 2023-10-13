//
//  TodoListView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/12.
//


import SwiftUI
import CoreData
import WidgetKit

struct ContentView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.managedObjectContext) var context
//  @EnvironmentObject var todoModel: TodoViewModel
  @StateObject var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  
  @State private var animatingButton: Bool = false
  @Environment(\.widgetFamily) var family
  @FetchRequest(entity: Todo.entity(),
               sortDescriptors: [
                 NSSortDescriptor(keyPath: \Todo.name, ascending: true)
               ]
  ) var todos:FetchedResults<Todo>
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      ZStack {
        List{
          ForEach(todos, id: \.self) { todo in
            TodoItemView(todoModel: todoModel, todo: todo)
          }// END: FOREACH
          .onDelete(perform: deleteTodo)
        }// END: LIST
        
        if todoModel.todos.count == 0 {
          EmptyView()
        }
      }  // END: ZSTACK
      // MARK: - SHEET
      .sheet(isPresented: $todoModel.isNewTodo) {
        AddTodoView(todoModel: todoModel)
      }
      // MARK: - ORVERLAY
      .overlay(
        ZStack {
          // MARK: - BACKGROUND CIRCLE
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
          }// MARK: - BACKGROUND CIRCLE
          
          
          
          // MARK: - ADD BUTTON
          Button(action: {
            print("Before - todoModel.isNewTodo: \(todoModel.isNewTodo)")
            todoModel.isNewTodo.toggle()
            print("After - todoModel.isNewTodo: \(todoModel.isNewTodo)")
//            context.refreshAllObjects()
//
//            todoModel.fetchTodos()
          }) {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .scaledToFit()
              .background(Circle().fill(.white))
              .frame(width: 50, alignment: .center)
          } //: BUTTON
          .accentColor(.blue)
          // MARK: - ON APPEAR
          .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
              animatingButton.toggle() // またはアニメーションする他の値
            }
          }
          // MARK: - ON DISAPPEAR
          .onDisappear{
            self.animatingButton=false
          }
          
          //実行済みのTodoがある場合のみ
          if todos.filter({ $0.state }).count > 0 {
          ZStack{
              Circle()
                .fill(.red)
                .opacity(0.8)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(width: 70, height: 88, alignment: .center)
            
            //実行済みのタスクを削除

              // MARK: - DELETE BUTTON
              Button(action: {
                for todo in todos.filter({ $0.state })
                {
                    print("削除するtodo: \(todo.name!)")
                    context.delete(todo)
                    do {
                      try context.save()
                    } catch {
                      print(error.localizedDescription)
                    }
                }
                
                WidgetCenter.shared.reloadAllTimelines()
              }) {
                Image(systemName: "trash")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(.white)
                  .frame(width: 30, alignment: .center)
                
              } //: BUTTON
              
              
          }.offset(x: -275, y: 0)
                    }

        } //: ZSTACK
          .padding(.bottom, 15)
          .padding(.trailing, 15)
        , alignment: .bottomTrailing
      ) //: OVERLAY
      
      .navigationBarTitle("Todo", displayMode: .inline)
//      .navigationBarItems(
//        leading: EditButton(),
//        trailing:
//          Button(action: {
//            todoModel.isNewTodo.toggle()
//          }) {
//            Image(systemName: "pencil.and.outline")
//              .padding()
//          } // END: ADD BUTTON
//      )
    }// END: NAVIGATION VIEW
    .onOpenURL(perform: { url in
      todoModel.isNewTodo = true
    })
    
    
  } // END: BODY
  
  
  // MARK: - FUNCTIONS
  
  private func deleteTodo(at offsets: IndexSet) {
    for index in offsets {
      let todo = todoModel.todos[index]
      context.delete(todo)
      do {
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
      } catch {
        context.rollback()
        print("ContentViewでエラー")
        print(error.localizedDescription)
      }
    }
  }
  
}// END: CONTENTVIEW


// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
  }
}
