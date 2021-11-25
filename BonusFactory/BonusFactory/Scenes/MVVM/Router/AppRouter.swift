//
//  AppRouter.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

class AppRouter: ObservableObject {

    private var services: Services
    private var _scene: Scene = .start
    //private var _alert: Alert?

    @Published var isPush: Bool = false
    //@Published var isAlertActive: Bool = false
        
    // MARK: - Initialization
    init(services: Services) {
        self.services = services
    }
    
    func push(_ scene: Scene) {
        _scene = scene
        isPush.toggle()
    }

    private func loginView() -> some View {
        let view = LoginScene(viewModel: AnyViewModel(LoginViewModel(services: services, router: self)))
        return NavigationRouterView(router: self, initView: view)
    }

    private func tabBarView() -> some View {
        return TabBarView()
    }

    private func startScene() -> some View {
        let view = StartScene(viewModel: AnyViewModel(StartViewModel(services: services, router: self)))
        return NavigationRouterView(router: self, initView: view)
    }

}

extension AppRouter: Router {
    @ViewBuilder func scene() -> some View {
        switch _scene {
        case .start:
            startScene()
        case .login:
            loginView()
        case .tabBar:
            tabBarView()
        }
    }
}
