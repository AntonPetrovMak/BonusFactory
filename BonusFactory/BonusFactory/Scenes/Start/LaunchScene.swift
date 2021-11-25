//
//  LaunchScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

enum LaunchEvent {
    case onLogin
}

struct LaunchScene: View {
    
    @ObservedObject var viewModel: LaunchViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
}
