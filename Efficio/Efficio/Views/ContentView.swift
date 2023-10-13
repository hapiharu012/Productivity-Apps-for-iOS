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
  @StateObject var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  @State private var animatingButton: Bool = false
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      ZStack {
        List{
          ForEach(todoModel.todos, id: \.self) { todo in
            TodoItemView(todoModel: todoModel, todo: todo)
          }// END: FOREACH
          .onDelete(perform: todoModel.deleteTodo)
          .onMove(perform: todoModel.moveTodo)
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
        HStack{
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
//                .shadow(radius: animatingButton ? 0 : 5)
            } //: BUTTON
            .accentColor(.blue)
            
          }.position(x: 325, y: 680)
          
          
          
          //MARK: - DELETE COMPLETED TODOS BUTTON
          if todoModel.todos.filter({ $0.state }).count > 0 { //実行済みのTodoがある場合のみ
            ZStack{
              Circle()
                .fill(.red)
                .opacity(0.8)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(width: 60, height: 88, alignment: .center)
              
              Button(action: {  //実行済みのタスクを削除
                print("完了したTodoのみ削除")
                todoModel.deleteAllCompletedTodo()
              }) {
                Image(systemName: "trash")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(.white)
                  .frame(width: 30, alignment: .center)
              }
            }
            .position(x: -130, y: 680)
          }//DELETE COMPLETED TODOS BUTTON
          else {
            SwiftUI.EmptyView()
          }
        }// END: HSTACK
          
//        } //: ZSTACK
          
      ) //: OVERLAY
      
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
      .navigationBarTitle("Todo", displayMode: .inline)
    }// END: NAVIGATION VIEW
    
    // MARK: - ON OPEN URL FROM WIDGET
    .onOpenURL(perform: { url in
      todoModel.isNewTodo = true
    })
    
    
  } // END: BODY
}// END: CONTENTVIEW


// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
  }
}
