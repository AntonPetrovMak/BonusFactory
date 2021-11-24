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
    
    init() {
        Services.shared.configServices()
    }
    
    var body: some Scene {
        WindowGroup {
            StartScene(viewModel: AnyViewModel(StartViewModel()))
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
