//
//  TodoListView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/12.
//


import SwiftUI

struct ContentView: View {
  // MARK: - PROPERTIES
  
  @StateObject var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
  @State private var animatingButton: Bool = false
  @State private var showingSettingsView: Bool = false
  
  // THEME
  @ObservedObject var theme = ThemeViewModel.shared
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      ZStack {
        List{
          ForEach(todoModel.todos, id: \.self) { todo in
            TodoItemView(todoModel: todoModel, todo: todo)
              .padding(.vertical, 9)
          }// : FOREACH
          .onDelete(perform: todoModel.deleteTodo)
          .onMove(perform: todoModel.moveTodo)
          
          .padding(.all, 10)
          .frame(maxWidth: .infinity, minHeight: 60)
          .background(theme.rowColor.opacity(1))
          .listRowBackground(theme.backgroundColor)
          .listRowSeparator(.hidden)
          .cornerRadius(10)
          
        }// : LIST
        .listStyle(.plain)
        .background(theme.backgroundColor)
        
        if todoModel.todos.count == 0 {
          EmptyView(theme: theme)
        }
      }  // : ZSTACK
      
      // MARK: - SHEET
      .sheet(isPresented: $todoModel.isNewTodo) {
        AddTodoView(todoModel: todoModel, theme: theme)
      }
      
      .overlay(
        // MARK: - FOOTER BUTTONS
        HStack{
          // MARK: - ADD BUTTON
          ZStack {
            Group {
              Circle()
                .fill(LinearGradient(
                  colors: [
                    theme.accentColor,
                    theme.backgroundColor
                  ],
                  startPoint: animatingButton ? .topLeading : .bottomLeading,
                  endPoint: animatingButton ? .bottomTrailing : .topTrailing
                )).contrast(5.0)
                .opacity(self.animatingButton ? 0.2 : 0)
                .scaleEffect(self.animatingButton ? 1 : 0)
                .frame(width: 68, height: 68, alignment: .center)
              Circle()
                .fill(LinearGradient(
                  colors: [
                    theme.accentColor,
                    theme.backgroundColor
                  ],
                  startPoint: animatingButton ? .topLeading : .bottomLeading,
                  endPoint: animatingButton ? .bottomTrailing : .topTrailing
                )).contrast(5.0)
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
                .foregroundColor(theme.accentColor).contrast(1.5)
                .background(Circle().fill(theme.backgroundColor))
                .frame(width: 50, alignment: .center)
                .shadow(radius: animatingButton ? 6 : 0)
            } //: BUTTON
            
          }//: ADD BUTTON
          .position(x: 325, y: 680)
          
          
          
          //MARK: - DELETE COMPLETED TODOS BUTTON
          if todoModel.todos.filter({ $0.state }).count > 0 { //実行済みのTodoがある場合のみ
            ZStack{
              Circle()
                .fill(.white)
                .opacity(0.6)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(width: 60, height: 88, alignment: .center)
              
              Button(action: {  //実行済みのタスクを削除
                print("完了したTodoのみ削除")
                todoModel.deleteAllCompletedTodo()
              }) {
                Image(systemName: "trash")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(theme.backgroundColor)
                  .frame(width: 30, alignment: .center)
              }
            }
            .position(x: -130, y: 680)
          } //: DELETE COMPLETED TODOS BUTTON
          else {
            SwiftUI.EmptyView()
          } //: ELSE
          
        } //: FOOTER BUTTONS
      ) //: OVERLAY
      .navigationBarTitle("Todo", displayMode: .inline)
      
      .navigationBarItems(
        trailing:
          Button(action: {
            self.showingSettingsView.toggle()
          }) {
            Image(systemName: "paintbrush")
              .imageScale(.large)
              .foregroundColor(.white)
          } //: SETTINGS BUTTON
          .accentColor(theme.accentColor)
          .sheet(isPresented: $showingSettingsView) {
            SettingsView(theme: theme)
          }
      )
      
      .toolbarBackground(theme.backgroundColor,for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(theme.getNavigationForegroundColor(for: colorScheme) ? .dark : .light)
      
      // MARK: - ON APPEAR
      .onAppear {
        withAnimation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
          animatingButton.toggle() // アニメーションする値
        }
      }
      
      // MARK: - ON DISAPPEAR
      .onDisappear{
        self.animatingButton=false
      }
      
    } // : NAVIGATION
    
  } //: BODY
  
} //: CONTENTVIEW



// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
  }
}
