//
//  LoginScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

struct LoginState {
    
}

enum LoginEvent {
    
}

struct LoginScene: View {
    
    @ObservedObject var viewModel: AnyViewModel<LoginState, LoginEvent>
    
    var body: some View {
        Text("Login!")
            .padding()
    }
}
