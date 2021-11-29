//
//  DashboardScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import SwiftUI

protocol DashboardVMP: ObservableObject {
    var points: String { get }
    var userName: String { get }
    var companyName: String { get }
}

struct DashboardScene<ViewModel: DashboardVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Points: \(viewModel.points)")
                Text("User name: \(viewModel.userName)")
                Text("Organization name: \(viewModel.companyName)")
                .font(.system(size: 16))
                Spacer()
            }
            .navigationBarTitle(Text("Dashboard"), displayMode: .automatic)
            .padding()
        }
    }
}

