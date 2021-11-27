//
//  LoginRouter.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import Combine
import SwiftUI

protocol LoginRouterProtocol {
    func showConfirmScene()
}

class LoginRouter: ObservableObject {
    
    // MARK: - Private vars
    private var services: Services
    private var anyCancellables = Set<AnyCancellable>()

    @Published var isActive = false
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
        LoginScene(viewModel: LoginViewModel(services: services, router: self))
    }
    
    @ViewBuilder func confirmSMSScene() -> some View {
        ConfirmSMSScene(viewModel: ConfirmSMSViewModel(services: services))
    }
}

extension LoginRouter: LoginRouterProtocol {
    func showConfirmScene() {
        isActive = true
    }
}

struct LoginRouterView: View {
    @StateObject var router: LoginRouter
    
    var body: some View {
        NavigationView {
            VStack {
                self.router.loginScreen()
                NavigationLink("", destination: self.router.confirmSMSScene(), isActive: $router.isActive)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
