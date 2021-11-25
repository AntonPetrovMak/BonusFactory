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
        VStack { Text("Dashboard") }
    }

    @ViewBuilder func qrTab() -> some View {
        VStack { Text("QR") }
    }

    @ViewBuilder func settingsTab() -> some View {
        VStack { Text("Settings") }
    }
}

struct TabBarRouterView: View {
    @StateObject var router: TabBarRouter
    
    var body: some View {
        TabView {
            router.dashboardTab()
                .tabItem {
                    Label("Dashboard", systemImage: "questionmark.circle.fill")
                }

            router.qrTab()
                .tabItem {
                    Label("QR", systemImage: "house.fill")
                }
            
            router.settingsTab()
                .tabItem {
                    Label("Settings", systemImage: "person.fill")
                }
        }
    }
}
