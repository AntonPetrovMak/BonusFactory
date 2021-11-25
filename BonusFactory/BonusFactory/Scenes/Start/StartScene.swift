//
//  StartScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

struct StartState {
    var isLoading: Bool
}

enum StartEvent {
    case onLogin
}

struct StartScene: View {
    
    @ObservedObject var viewModel: AnyViewModel<StartState, StartEvent>
    
    var body: some View {
        VStack {
            Button("Log in") {
                viewModel.trigger(.onLogin)
            }
            if viewModel.state.isLoading {
                Text("Loading ...!")
                    .padding()
            }
        }
    }
}
