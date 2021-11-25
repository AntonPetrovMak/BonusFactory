//
//  LoginRouter.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import Combine
import SwiftUI

class LoginRouter: ObservableObject {
    
    // MARK: - Private vars
    private var services: Services
        
    // MARK: - Initialization
    init(services: Services) {
        self.services = services
        Logger.print("init:\(self)")
    }
    
    deinit {
        Logger.print("deinit:\(self)")
    }
    
    // MARK: - Methods
    @ViewBuilder func loginScreen() -> some View {
        LoginScene(viewModel: LoginViewModel(services: services))
    }
    
    @ViewBuilder func confirmSMSScene() -> some View {
        VStack {
            Text("Confirm SMS")
        }
    }
}

struct LoginRouterView: View {
    @StateObject var router: LoginRouter
    
    var body: some View {
        NavigationView {
            self.router.loginScreen()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
