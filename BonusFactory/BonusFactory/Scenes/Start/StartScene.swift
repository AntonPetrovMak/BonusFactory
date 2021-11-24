//
//  StartScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

struct StartState {
    let isLoading: Bool
}

enum StartEvent {

}

struct StartScene: View {
    
    @ObservedObject var viewModel: AnyViewModel<StartState, StartEvent>
    
    var body: some View {
        if viewModel.state.isLoading {
            Text("Loading ...!")
                .padding()
        } else {
            Text("Loaded")
                .padding()
        }
        
    }
}
