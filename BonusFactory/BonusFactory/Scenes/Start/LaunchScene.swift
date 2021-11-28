//
//  LaunchScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

struct LaunchScene: View {
    
    @ObservedObject var viewModel: LaunchViewModel
    
    var body: some View {
        VStack {
                ProgressView()
                    .padding()
        }
    }
}
