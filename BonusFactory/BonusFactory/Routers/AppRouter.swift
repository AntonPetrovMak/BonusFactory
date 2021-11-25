//
//  AppRouter.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import Combine
import SwiftUI

enum AppRouterScreen {
    case launch
    case login
    case tab
}

class AppRouter: ObservableObject {
    // MARK: - Published vars
    @Published var screen: AppRouterScreen = .login
    
    // MARK: - Private vars
    private var services: Services
    private var anyCancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(services: Services) {
        self.services = services
        setBindings()
        Logger.print("init:\(self)")
    }
    
    deinit {
        Logger.print("deinit: \(self)")
    }
    // MARK: - Private Methods
    private func setBindings() {
        services.authService.isLoggedIn.sink { [weak self] value in
            if value == true {
                self?.screen = .tab
            } else {
                self?.screen = .login
            }
        }.store(in: &self.anyCancellables)
    }
    
    // MARK: - Methods
    @ViewBuilder func loginScreen() -> some View {
        LoginRouterView(router: LoginRouter(services: self.services))
    }
    
    @ViewBuilder func tabScreen() -> some View {
        TabBarRouterView(router: TabBarRouter(services: self.services))
    }

    @ViewBuilder func lauchScreen() -> some View {
        LaunchScene(viewModel: LaunchViewModel(services: services))
    }
}

struct AppRouterView: View {
    @StateObject var router: AppRouter
    
    var body: some View {
        switch self.router.screen {
        case .launch:
            router.lauchScreen()
        case .login:
            router.loginScreen()
        case .tab:
            router.tabScreen()
        }
    }
}
