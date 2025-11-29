//
//  TodoListView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/12.
//


import SwiftUI

struct ContentView: View {
  // MARK: - CONSTANTS
  
  private enum Constants {
    // Button sizes
    static let deleteButtonSize: CGFloat = 60
    static let addButtonSize: CGFloat = 50
    static let addButtonBackgroundSize: CGFloat = 68
    static let addButtonBackgroundSizeLarge: CGFloat = 88
    
    // List styling
    static let todoListRowPadding: CGFloat = 10
    static let todoListRowMinHeight: CGFloat = 60
    static let todoListRowCornerRadius: CGFloat = 10
    
    // Visual effects
    static let buttonShadowRadius: CGFloat = 10
    static let addButtonShadowRadius: CGFloat = 6
    static let buttonOpacity: Double = 0.6
    static let contrastValue: Double = 5.0
    static let scaleEffect: CGFloat = 1
    
    // Animation
    static let addButtonAnimationDuration: Double = 1.8
  }
  
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
        TodoListView(
          todoModel: todoModel,
          theme: theme
        )

        if todoModel.todos.count == 0 {
          EmptyView(theme: theme)
        }
      }  // : ZSTACK
    
      
      .overlay(
        FooterButtonsView(
          todoModel: todoModel,
          theme: theme,
          animatingButton: animatingButton
        )
      ) //: OVERLAY
      // MARK: - SHEET
      .sheet(isPresented: $todoModel.isNewTodo) {
        AddTodoView(todoModel: todoModel, theme: theme)
      }
      // MARK: - ALERT
      .alert(isPresented: $todoModel.errorShowing2) {
        Alert(title: Text(todoModel.errorTitle), message: Text(todoModel.errorMessage), dismissButton: .default(Text("OK")){
          todoModel.errorShowing2 = false
        })
        
      }
#if !os(macOS)
      .navigationBarTitle("Todo", displayMode: .inline)
      .navigationBarItems(
        trailing: NavigationBarView(
          showingSettingsView: $showingSettingsView,
          theme: theme
        )
      )
      .toolbarBackground(theme.backgroundColor,for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(theme.determineTheFontColor(for: colorScheme) ? .dark : .light)
#endif

      // MARK: - ON APPEAR
      .onAppear {
        withAnimation(Animation.easeInOut(duration: Constants.addButtonAnimationDuration).repeatForever(autoreverses: true)) {
          animatingButton.toggle() // アニメーションする値
        }
      }
      
      
      // MARK: - ON DISAPPEAR
      .onDisappear{
        self.animatingButton=false
      }
      
    } // : NAVIGATION
    .onOpenURL(perform: { url in
          todoModel.isNewTodo = true
        })
    .navigationViewStyle(StackNavigationViewStyle())
    
  } //: BODY
  
} //: CONTENTVIEW

// MARK: - COMPONENTS

struct TodoListView: View {
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var theme: ThemeViewModel
  
  private enum Constants {
    static let todoItemVerticalPadding: CGFloat = 9
    static let todoRowPadding: CGFloat = 10
    static let todoRowMinHeight: CGFloat = 60
    static let todoRowCornerRadius: CGFloat = 10
    static let filterSectionPadding: CGFloat = 16
    static let filterButtonSpacing: CGFloat = 8
    static let filterButtonHeight: CGFloat = 36
    static let filterButtonCornerRadius: CGFloat = 18
  }
  
  var body: some View {
    VStack(spacing: 0) {
      // フィルタードロップダウン
      FilterDropdownView(todoModel: todoModel, theme: theme)
        .background(theme.backgroundColor)

      // Todoリスト
      List {
        ForEach(todoModel.filteredTodos, id: \.self) { todo in
          TodoItemView(todoModel: todoModel, todo: todo, theme: theme)
            .padding(.vertical, Constants.todoItemVerticalPadding)
        }
        .onDelete(perform: todoModel.deleteTodo)
        .onMove(perform: todoModel.moveTodo)
        .padding(.all, Constants.todoRowPadding)
        .frame(maxWidth: .infinity, minHeight: Constants.todoRowMinHeight)
        .background(theme.rowColor.opacity(1))
        .listRowBackground(theme.backgroundColor)
        .listRowSeparator(.hidden)
        .cornerRadius(Constants.todoRowCornerRadius)
      }
      .listStyle(.plain)
    }
    .background(theme.backgroundColor)
  }
}

struct FooterButtonsView: View {
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var theme: ThemeViewModel
  let animatingButton: Bool
  
  var body: some View {
    VStack {
      Spacer()
      HStack {
        if todoModel.todos.filter({ $0.state }).count > 0 {
          DeleteCompletedButtonView(todoModel: todoModel, theme: theme)
        } else {
          Spacer()
        }
        
        Spacer()
        
        AddButtonView(
          todoModel: todoModel,
          theme: theme,
          animatingButton: animatingButton
        )
      }
    }
    .padding(.horizontal, 15)
  }
}

struct DeleteCompletedButtonView: View {
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var theme: ThemeViewModel
  
  private enum Constants {
    static let deleteButtonSize: CGFloat = 60
    static let deleteButtonHeight: CGFloat = 88
    static let deleteButtonOpacity: Double = 0.6
    static let deleteButtonShadowRadius: CGFloat = 10
    static let trashIconSize: CGFloat = 30
    static let deleteButtonLeadingPadding: CGFloat = 17
  }
  
  var body: some View {
    ZStack {
      Circle()
        .fill(.white)
        .opacity(Constants.deleteButtonOpacity)
        .shadow(radius: Constants.deleteButtonShadowRadius)
        .frame(width: Constants.deleteButtonSize, height: Constants.deleteButtonHeight, alignment: .center)
      
      Button(action: {
        todoModel.deleteAllCompletedTodo()
      }) {
        Image(systemName: "trash")
          .resizable()
          .scaledToFit()
          .foregroundColor(theme.backgroundColor)
          .frame(width: Constants.trashIconSize, alignment: .center)
      }
    }
    .padding(.leading, Constants.deleteButtonLeadingPadding)
  }
}

struct AddButtonView: View {
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var theme: ThemeViewModel
  let animatingButton: Bool
  
  private enum Constants {
    static let addButtonIconSize: CGFloat = 50
    static let addButtonBackgroundCircleSize: CGFloat = 68
    static let addButtonBackgroundCircleSizeLarge: CGFloat = 88
    static let addButtonBackgroundCircleOpacity: Double = 0.2
    static let addButtonBackgroundCircleOpacityLarge: Double = 0.15
    static let addButtonContrastValue: Double = 5.0
    static let addButtonScaleEffect: CGFloat = 1
    static let addButtonShadowRadius: CGFloat = 6
    static let addButtonIconContrast: Double = 1.5
    static let addButtonBackgroundSize: CGFloat = 30
  }
  
  var body: some View {
    ZStack {
      // Background Circles
      Group {
        Circle()
          .fill(LinearGradient(
            colors: [theme.accentColor, theme.backgroundColor],
            startPoint: animatingButton ? .topLeading : .bottomLeading,
            endPoint: animatingButton ? .bottomTrailing : .topTrailing
          ))
          .contrast(Constants.addButtonContrastValue)
          .opacity(animatingButton ? Constants.addButtonBackgroundCircleOpacity : 0)
          .scaleEffect(animatingButton ? Constants.addButtonScaleEffect : 0)
          .frame(width: Constants.addButtonBackgroundCircleSize, height: Constants.addButtonBackgroundCircleSize, alignment: .center)
        
        Circle()
          .fill(LinearGradient(
            colors: [theme.accentColor, theme.backgroundColor],
            startPoint: animatingButton ? .topLeading : .bottomLeading,
            endPoint: animatingButton ? .bottomTrailing : .topTrailing
          ))
          .contrast(Constants.addButtonContrastValue)
          .opacity(animatingButton ? Constants.addButtonBackgroundCircleOpacityLarge : 0)
          .scaleEffect(animatingButton ? Constants.addButtonScaleEffect : 0)
          .frame(width: Constants.addButtonBackgroundCircleSizeLarge, height: Constants.addButtonBackgroundCircleSizeLarge, alignment: .center)
      }
      
      // Add Button
      Button(action: {
        todoModel.isNewTodo = true
      }) {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .scaledToFit()
          .foregroundColor(theme.accentColor).contrast(Constants.addButtonIconContrast)
          .background(Circle().fill(theme.backgroundColor).frame(width: Constants.addButtonBackgroundSize))
          .frame(width: Constants.addButtonIconSize, alignment: .center)
          .shadow(radius: animatingButton ? Constants.addButtonShadowRadius : 0)
      }
    }
  }
}

struct NavigationBarView: View {
  @Binding var showingSettingsView: Bool
  @ObservedObject var theme: ThemeViewModel
  
  var body: some View {
    Button(action: {
      showingSettingsView.toggle()
    }) {
      Image(systemName: "paintbrush")
        .imageScale(.large)
        .foregroundColor(.white)
    }
    .accentColor(theme.accentColor)
    .sheet(isPresented: $showingSettingsView) {
      SettingsView(theme: theme)
    }
  }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
  }
}
