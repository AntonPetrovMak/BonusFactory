//
//  BonusFactoryApp.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI
import Firebase

@main
struct BonusFactoryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {

    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            if let services = delegate.services {
                AppRouterView(router: AppRouter(services: services))
            } else {
                Text("Text")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var services: Services?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        self.services = AppServices()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("\(#function)")
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}
