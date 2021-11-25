//
//  BonusFactoryApp.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

@main
struct BonusFactoryApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    private let services: Services
    private let router: AppRouter
    
    init() {
        let services = AppServices()
        self.services = services
        self.router = AppRouter(services: services)
    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            router.scene()
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }
    }
}
