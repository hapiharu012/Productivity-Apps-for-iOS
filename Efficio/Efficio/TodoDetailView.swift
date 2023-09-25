//
//  TodoDetailView.swift
//  Efficio
//
//  Created by k21123kk on 2023/09/25.
//

import SwiftUI

struct TodoDetailView: View {
  @ObservedObject var todo: Todo
    var body: some View {
      Text(todo.name!)
    }
}

//#Preview {
//    TodoDetailView()
//}
