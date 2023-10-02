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
  
  @Environment(\.managedObjectContext) var context
  @StateObject private var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  
  @State private var animatingButton: Bool = false
  
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      ZStack {
        List{
          ForEach(todoModel.todos, id: \.self) { todo in
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
        } //: ZSTACK
          .padding(.bottom, 15)
          .padding(.trailing, 15)
        , alignment: .bottomTrailing
      ) //: OVERLAY
      
      .navigationBarTitle("Todo", displayMode: .inline)
      .navigationBarItems(
        leading: EditButton(),
        trailing:
          Button(action: {
            todoModel.isNewTodo.toggle()
          }) {
            Image(systemName: "pencil.and.outline")
              .padding()
          } // END: ADD BUTTON
      )
    }// END: NAVIGATION VIEW
    
    
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
