//
//  FilterDropdownView.swift
//  Efficio
//
//  Filter dropdown component based on Figma design
//

import SwiftUI

struct FilterDropdownView: View {
  @ObservedObject var todoModel: TodoViewModel
  @ObservedObject var theme: ThemeViewModel
  @Environment(\.colorScheme) var colorScheme
  @State private var autoCloseTask: DispatchWorkItem?

  private enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let headerHeight: CGFloat = 36
    static let headerCornerRadius: CGFloat = 18
    static let sectionSpacing: CGFloat = 12
    static let sectionLabelFontSize: CGFloat = 12
    static let itemHeight: CGFloat = 33
    static let itemCornerRadius: CGFloat = 10
    static let itemBackgroundOpacity: Double = 0.3
    static let checkmarkSize: CGFloat = 16
  }

  var body: some View {
    VStack(spacing: 0) {
      // Header button to toggle dropdown
      Button(action: {
        withAnimation(.easeInOut(duration: 0.3)) {
          todoModel.isFilterExpanded.toggle()
        }
      }) {
        HStack {
          Text(filterSummary)
            .font(.system(size: 14))
            .foregroundColor(textColor.opacity(0.7))

          Spacer()

          Image(systemName: "chevron.down")
            .font(.system(size: 12))
            .foregroundColor(textColor.opacity(0.7))
            .rotationEffect(.degrees(todoModel.isFilterExpanded ? 180 : 0))
        }
        .padding(.horizontal, 16)
        .frame(height: Constants.headerHeight)
        .background(
          RoundedRectangle(cornerRadius: Constants.headerCornerRadius)
            .fill(theme.rowColor.opacity(Constants.itemBackgroundOpacity))
        )
      }
      .padding(.horizontal, Constants.horizontalPadding)

      // Dropdown content
      if todoModel.isFilterExpanded {
        VStack(spacing: Constants.sectionSpacing) {
          // Display section
          displaySection

          // Sort by section
          sortBySection

          // Sort order section
          sortOrderSection
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, 12)
        .transition(.opacity.combined(with: .move(edge: .top)))
      }
    }
    .padding(.vertical, 8)
    .background(theme.backgroundColor)
  }

  // MARK: - Helper Functions

  /// 項目タップ時に3秒後に自動で閉じるタイマーをセット（既存のタイマーはリセット）
  private func scheduleAutoClose() {
    // 既存のタイマーをキャンセル
    autoCloseTask?.cancel()

    // 新しい3秒タイマーをセット
    let task = DispatchWorkItem {
      withAnimation(.easeInOut(duration: 0.3)) {
        todoModel.isFilterExpanded = false
      }
    }
    autoCloseTask = task
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: task)
  }

  // MARK: - Filter Summary
  private var filterSummary: String {
    let sortText = todoModel.sortBy.rawValue
    let orderText = sortOrderText(for: todoModel.sortOrder)
    let countText = "\(todoModel.filteredTodos.count)件"
    let displayText = todoModel.showCompleted ? "完了タスク表示" : "完了タスク非表示"

    return "\(sortText) · \(orderText) · \(countText) · \(displayText)"
  }

  // MARK: - Display Section
  private var displaySection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("表示")
        .font(.system(size: Constants.sectionLabelFontSize))
        .foregroundColor(sectionLabelColor)
        .padding(.leading, 4)

      Button(action: {
        todoModel.showCompleted.toggle()
        scheduleAutoClose()  // タップ時に3秒タイマーをセット
      }) {
        HStack {
          Image(systemName: todoModel.showCompleted ? "eye" : "eye.slash")
            .font(.system(size: Constants.checkmarkSize))
            .foregroundColor(displayButtonForegroundColor)

          Text(todoModel.showCompleted ? "完了タスク表示" : "完了タスク非表示")
            .font(.system(size: 14))
            .foregroundColor(displayButtonForegroundColor)

          Spacer()

          Text("\(completedCount)")
            .font(.system(size: 12))
            .foregroundColor(displayButtonForegroundColor.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .frame(height: Constants.itemHeight)
        .background(
          RoundedRectangle(cornerRadius: Constants.itemCornerRadius)
            .fill(displayButtonBackgroundColor)
        )
      }
    }
  }

  // MARK: - Sort By Section
  private var sortBySection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("並び替え基準")
        .font(.system(size: Constants.sectionLabelFontSize))
        .foregroundColor(sectionLabelColor)
        .padding(.leading, 4)

      Picker("", selection: $todoModel.sortBy) {
        ForEach(TodoViewModel.SortCriteria.allCases, id: \.self) { criteria in
          Text(criteria.rawValue)
            .tag(criteria)
        }
      }
      .pickerStyle(.segmented)
      .background(theme.rowColor)
      .cornerRadius(9)
      .onChange(of: todoModel.sortBy) { _ in
        scheduleAutoClose()  // ピッカー変更時に3秒タイマーをセット
      }
    }
  }

  // MARK: - Sort Order Section
  private var sortOrderSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("並び順")
        .font(.system(size: Constants.sectionLabelFontSize))
        .foregroundColor(sectionLabelColor)
        .padding(.leading, 4)

      Picker("", selection: $todoModel.sortOrder) {
        ForEach(TodoViewModel.SortOrder.allCases, id: \.self) { order in
          Text(sortOrderText(for: order))
            .tag(order)
        }
      }
      .pickerStyle(.segmented)
      .background(theme.rowColor)
      .cornerRadius(9)
      .onChange(of: todoModel.sortOrder) { _ in
        scheduleAutoClose()  // ピッカー変更時に3秒タイマーをセット
      }
    }
  }

  // MARK: - Computed Properties
  private var completedCount: Int {
    todoModel.todos.filter { $0.state }.count
  }

  private var textColor: Color {
    theme.getTodoItemForegroundColor(for: colorScheme) ? .white : .black
  }

  private var foregroundColor: Color {
    theme.determineTheFontColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black
  }

  // 非選択時のテキスト色（完了済みボタン用）
  private var unselectedTextColor: Color {
    if colorScheme == .dark {
      return .white.opacity(0.85)
    } else {
      return .black.opacity(0.75)
    }
  }

  // セクションラベルの色（AddTodoViewと同じロジック）
  private var sectionLabelColor: Color {
    theme.determineTheFontColor(for: colorScheme) ? .white : colorScheme == .dark ? .white : .black
  }

  // 表示フィルターボタンの前景色（AddTodoViewのsaveButtonForegroundColorと同じロジック）
  private var displayButtonForegroundColor: Color {
    theme.getSaveButtonForegroudColor() ? .black : colorScheme == .dark ? .black : .white
  }

  // 表示フィルターボタンの背景色（showCompletedの状態に応じて明度を調整）
  private var displayButtonBackgroundColor: Color {
    if todoModel.showCompleted {
      // 完了タスク表示中: 通常のアクションカラー
      return theme.accentColor
    } else {
      // 完了タスク非表示中: 明度を下げて視覚的に区別
      return theme.accentColor.opacity(0.6)
    }
  }

  // 並び順の表示テキストを並び替え基準に応じて変更
  private func sortOrderText(for order: TodoViewModel.SortOrder) -> String {
    switch todoModel.sortBy {
    case .priority:
      // 優先度の場合
      return order == .ascending ? "高い順" : "低い順"
    case .deadline:
      // 期日の場合
      return order == .ascending ? "早い順" : "遅い順"
    }
  }
}

// MARK: - Preview
struct FilterDropdownView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // ミッドナイトブルー
      FilterDropdownView(
        todoModel: TodoViewModel(context: PersistenceController.preview.container.viewContext),
        theme: ThemeViewModel(forPreview: 0)
      )
      .background(themeData[0].backColor)
      .previewDisplayName("ミッドナイトブルー")
      .previewLayout(.sizeThatFits)

      // モノトーンミニマル
      FilterDropdownView(
        todoModel: TodoViewModel(context: PersistenceController.preview.container.viewContext),
        theme: ThemeViewModel(forPreview: 1)
      )
      .background(themeData[1].backColor)
      .previewDisplayName("モノトーンミニマル")
      .previewLayout(.sizeThatFits)

      // リフレッシュ
      FilterDropdownView(
        todoModel: TodoViewModel(context: PersistenceController.preview.container.viewContext),
        theme: ThemeViewModel(forPreview: 2)
      )
      .background(themeData[2].backColor)
      .previewDisplayName("リフレッシュ")
      .previewLayout(.sizeThatFits)

      // フォレストクリーム
      FilterDropdownView(
        todoModel: TodoViewModel(context: PersistenceController.preview.container.viewContext),
        theme: ThemeViewModel(forPreview: 3)
      )
      .background(themeData[3].backColor)
      .previewDisplayName("フォレストクリーム")
      .previewLayout(.sizeThatFits)
    }
  }
}
