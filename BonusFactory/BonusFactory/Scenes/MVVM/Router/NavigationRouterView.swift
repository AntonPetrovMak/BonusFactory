//
//  NavigationRouterView.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

struct NavigationRouterView<InitialView: View>: View {
    @StateObject var router: AppRouter
    var initView: InitialView
    
    var body: some View {
        NavigationView {
            VStack {
                initView
                NavigationLink("", destination: router.scene(), isActive: $router.isPush)
            }
            //.alert(isPresented: $router.isAlertActive, content: { router.alert() })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
