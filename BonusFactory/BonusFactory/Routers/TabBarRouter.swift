//
//  TabBarRouter.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import SwiftUI

class TabBarRouter: ObservableObject {
    // MARK: - Private vars
    private var services: Services
    
    // MARK: - Initialization
    init(services: Services) {
        self.services = services
        Logger.print("init:\(self)")
    }
    
    deinit {
        Logger.print("deinit: \(self)")
    }
    
    // MARK: - Methods
    @ViewBuilder func dashboardTab() -> some View {
        DashboardScene(viewModel: DashboardViewModel(services: services))
    }
    
    @ViewBuilder func qrTab() -> some View {
        QRScene(viewModel: QRViewModel(services: services))
    }

    @ViewBuilder func usePointsTab() -> some View {
        UsePointsScene(viewModel: UsePointsViewModel(services: services))
    }
    
    @ViewBuilder func settingsTab() -> some View {
        VStack {
            Button("Log out") {
                self.services.authService.signOut()
            }
        }
    }
}

struct TabBarRouterView: View {
    @StateObject var router: TabBarRouter
    
    var body: some View {
        TabView {
            NavigationView {
                router.dashboardTab()
            }
            .tabItem {
                Label("Dashboard", systemImage: "questionmark.circle.fill")
            }
            
            NavigationView {
                router.qrTab()
            }
            .tabItem {
                Label("QR", systemImage: "house.fill")
            }

            NavigationView {
                router.usePointsTab()
            }
            .tabItem {
                Label("Use Points", systemImage: "house.fill")
            }
            
            NavigationView {
                router.settingsTab()
            }
            .tabItem {
                Label("Settings", systemImage: "person.fill")
            }
        }
    }
}
