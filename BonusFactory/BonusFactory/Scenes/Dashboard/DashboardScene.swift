//
//  DashboardScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import SwiftUI

protocol DashboardVMP: ObservableObject {
    var points: String { get }
}

struct DashboardScene<ViewModel: DashboardVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 10) {
                    Text("Points:")
                    Text(viewModel.points)
                }
                .font(.system(size: 16))
                Spacer()
            }
            .navigationBarTitle(Text("Dashboard"), displayMode: .automatic)
            .padding()
        }
    }
}

