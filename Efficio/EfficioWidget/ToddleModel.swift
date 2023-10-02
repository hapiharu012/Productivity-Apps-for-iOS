//
//  ToddleModel.swift
//  Efficio
//
//  Created by k21123kk on 2023/10/02.
//

import Foundation
import SwiftUI

final class Toggle {
    static let shared: Toggle  = .init()
    @StateObject private var todoModel = TodoViewModel(context: PersistenceController.shared.container.viewContext)
    
    func togglState() {
        
      todoModel.state.toggle()
        
    }
}
