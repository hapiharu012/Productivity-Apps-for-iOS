

//
//  AddTodoView.swift
//  ToDo-List
//
//  Created by hapiharu012 on 2023/09/11.
//

import SwiftUI
import Combine


struct AddTodoView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.managedObjectContext) var context
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var todoModel: TodoViewModel
  
  let priorities = [3, 2, 1] // 3: 高, 2: 中, 1: 低
  let textLimit = 20 //最大文字数
  
  
  @State private var dateSetting = false
  @State private var timeSetting = false
  
  // フォーカスが当たるTextFieldを、判断するためのenumを作成します。
  enum Field: Hashable {
    case text
    case no
  }
  @FocusState private var focusedField: Field?
  
  // THEME
  @ObservedObject var theme: ThemeViewModel
  
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  
  
  let calendar = Calendar.current
  
#if os(iOS)
  let width = Int(UIScreen.main.bounds.width)
  let height = Int(UIScreen.main.bounds.height)
#elseif os(macOS)
  let width = NSScreen.main?.frame.width ?? 0
  let height = NSScreen.main?.frame.height ?? 0

#endif
 
  // MARK: - BODY
  var body: some View {
    NavigationView {
      mainContent
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .alert(isPresented: $todoModel.errorShowing1) {
      errorAlert
    }
    .onAppear {
      setupInitialState()
    }
    .onDisappear {
      cleanup()
    }
  }
  
  // MARK: - VIEW COMPONENTS
  private var mainContent: some View {
    VStack {
      contentVStack
        .padding(.horizontal)
        .padding(.top, 10)
    }
    .background(theme.backgroundColor)
    .navigationBarTitle("New Todo", displayMode: .inline)
    .navigationBarItems(trailing: closeButton)
    .toolbarBackground(theme.backgroundColor, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(theme.determineTheFontColor(for: colorScheme) ? .dark : .light)
  }
  
  private var contentVStack: some View {
    VStack(alignment: .leading, spacing: 15) {
          
      todoNameField

      prioritySection
          
      deadlineSection
      
      saveButton
      
      Spacer()
    }
  }
  
  private var todoNameField: some View {
    TextField("Todo", text: $todoModel.name)
      .focused($focusedField, equals: .text)
      .padding()
      .background(theme.rowColor)
      .cornerRadius(9)
      .font(.system(size: 24, weight: .bold, design: .default))
      .onReceive(Just(todoModel.name)) { _ in
        if todoModel.name.count > textLimit {
          todoModel.name = String(todoModel.name.prefix(textLimit))
        }
      }
  }
  
  private var prioritySection: some View {
    HStack {
      Text("優先度")
        .font(.footnote)
        .foregroundColor(foregroundColor)
      
      Picker("優先度", selection: $todoModel.priority) {
        ForEach(priorities, id: \.self) { priorityValue in
            Text(PriorityUtils.priorityText(for: Int16(priorityValue)))
                .tag(Int16(priorityValue))
        }
        .font(.footnote)
      }
      .pickerStyle(SegmentedPickerStyle())
      .background(theme.rowColor)
      .cornerRadius(9)
      .padding(.horizontal, 10)
      
      if todoModel.priority != 0 {
        Button(action: {
          todoModel.priority = 0
        }) {
          Image(systemName: "clear")
            .foregroundColor(theme.accentColor)
            .font(.system(size: 20, weight: .bold, design: .default))
        }
      }
    }
    .padding(.top, 5)
  }
  
  private var deadlineSection: some View {
    VStack {
      dateSection
      timeSection
    }
  }
  
  private var dateSection: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("日付")
          .font(.footnote)
          .foregroundColor(foregroundColor)
        
        if todoModel.deadline_date != nil {
          Text(calendar.formatDateAndOptimization(date: todoModel.deadline_date ?? Date()))
            .foregroundColor(Color.blue)
            .font(.footnote)
        } else {
          Text("none")
            .foregroundColor(Color.blue)
            .font(.footnote)
            .hidden()
        }
      }
      Spacer()
      
      if dateSetting {
        datePickerView
      } else {
        hiddenDatePickerView
      }
      
      Spacer()
        .frame(width: 35)
      
      Toggle(isOn: $dateSetting) {
        SwiftUI.EmptyView()
      }
      .toggleStyle(CustomToggleStyle())
    }
    .padding(.bottom, 6.5)
  }
  
  private var timeSection: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("日時")
          .font(.footnote)
          .foregroundColor(foregroundColor)
        
        if todoModel.deadline_time != nil {
          Text(calendar.formatTime(date: todoModel.deadline_time!))
            .foregroundColor(Color.blue)
            .font(.footnote)
        } else {
          Text(" ")
            .font(.footnote)
            .hidden()
        }
      }
      Spacer()
      
      if timeSetting {
        timePickerView
      } else {
        hiddenTimePickerView
      }
      
      Toggle(isOn: $timeSetting) {
        SwiftUI.EmptyView()
      }
      .toggleStyle(CustomToggleStyle())
    }
  }
  
  private var datePickerView: some View {
    Rectangle()
      .fill(theme.backgroundColor)
      .frame(width: 30, height: 40)
      .overlay(
        DatePicker(selection: dateBinding, displayedComponents: .date, label: {
          SwiftUI.EmptyView()
        })
        .onAppear {
          if todoModel.deadline_date == nil {
            todoModel.deadline_date = Date()
          }
        }
        .onDisappear {
          if !dateSetting {
            todoModel.deadline_date = nil
          }
        }
        .padding(.leading, -8)
        .padding(.trailing, -5)
        .background(theme.rowColor)
        .cornerRadius(9)
        .frame(width: 10, alignment: .leading)
        .environment(\.locale, Locale(identifier: "ja_JP"))
      )
  }
  
  private var hiddenDatePickerView: some View {
    Rectangle()
      .fill(theme.backgroundColor)
      .frame(width: 10, height: 40)
      .overlay(
        DatePicker(selection: timeBinding, displayedComponents: .hourAndMinute, label: {
          SwiftUI.EmptyView()
        })
        .padding(.leading, -8)
        .padding(.trailing, -5)
        .background(theme.rowColor)
        .cornerRadius(9)
        .frame(width: 10, alignment: .leading)
        .environment(\.locale, Locale(identifier: "ja_JP"))
        .hidden()
      )
  }
  
  private var timePickerView: some View {
    Rectangle()
      .fill(theme.backgroundColor)
      .frame(width: 10, height: 40)
      .overlay(
        DatePicker(selection: timeBinding, displayedComponents: .hourAndMinute, label: {
          SwiftUI.EmptyView()
        })
        .onAppear {
          if todoModel.deadline_time == nil {
            todoModel.deadline_time = Date()
          }
        }
        .onDisappear {
          if !timeSetting {
            todoModel.deadline_time = nil
          }
        }
        .padding(.leading, -8)
        .background(theme.rowColor)
        .cornerRadius(9)
        .frame(width: 10, alignment: .leading)
        .environment(\.locale, Locale(identifier: "ja_JP"))
      )
  }
  
  private var hiddenTimePickerView: some View {
    Rectangle()
      .fill(theme.backgroundColor)
      .frame(width: 10, height: 40)
      .overlay(
        DatePicker(selection: timeBinding, displayedComponents: .hourAndMinute, label: {
          SwiftUI.EmptyView()
        })
        .padding(.leading, -8)
        .background(theme.rowColor)
        .cornerRadius(9)
        .frame(width: 10, alignment: .leading)
        .environment(\.locale, Locale(identifier: "ja_JP"))
        .hidden()
      )
  }
  
  private var saveButton: some View {
    Button(action: {
      if todoModel.name != "" {
        todoModel.writeTodo(context: context)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
      } else {
        focusedField = nil
        todoModel.errorShowing1 = true
        todoModel.errorTitle = "Todo名が入力されていません"
        todoModel.errorMessage = "Todo名が入力されていないので入力してください。"
        return
      }
      presentationMode.wrappedValue.dismiss()
    }) {
      Text("保存")
        .font(.system(size: 24, weight: .bold, design: .default))
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(theme.accentColor)
        .cornerRadius(9)
        .foregroundColor(saveButtonForegroundColor)
    }
  }
  
  private var closeButton: some View {
    Button(action: {
      presentationMode.wrappedValue.dismiss()
      todoModel.isNewTodo = false
    }) {
      Image(systemName: "xmark")
        .foregroundColor(theme.accentColor)
        .padding()
    }
  }
  
  private var errorAlert: Alert {
    Alert(
      title: Text(todoModel.errorTitle),
      message: Text(todoModel.errorMessage),
      dismissButton: .default(Text("OK")) {
        todoModel.errorShowing1 = false
        focusedField = .text
      }
    )
  }
  
  // MARK: - LIFECYCLE FUNCTIONS
  
  private func setupInitialState() {
    focusedField = .text
    dateSetting = todoModel.deadline_date != nil
    timeSetting = todoModel.deadline_time != nil
  }
  
  private func cleanup() {
    todoModel.resetForm()
    focusedField = .no
  }
  
  // MARK: - COMPUTED PROPERTIES
  private var foregroundColor: Color {
    theme.determineTheFontColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black
  }
  
  private var saveButtonForegroundColor: Color {
    theme.getSaveButtonForegroudColor() ? .black : colorScheme == .dark ? .black : .white
  }
  
  private var dateBinding: Binding<Date> {
    Binding<Date>(
      get: { self.todoModel.deadline_date ?? Date() },
      set: { newValue in
        self.todoModel.deadline_date = newValue
      }
    )
  }
  
  private var timeBinding: Binding<Date> {
    Binding<Date>(
      get: { self.todoModel.deadline_time ?? Date() },
      set: { newValue in
        self.todoModel.deadline_time = newValue
      }
    )
  }
  
  // MARK: - HELPER FUNCTIONS
} //: VIEW

// MARK: - PREVIEW

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView(todoModel: TodoViewModel(context: PersistenceController.shared.container.viewContext), theme: ThemeViewModel.shared)
    
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
