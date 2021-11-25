//
//  Services.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation

protocol Services {
    var authService: AuthService { get }
}

class AppServices: Services {
    var authService: AuthService
        
    init() {
        let networkManager = AppNetworkManager()
        self.authService = AppAuthService(networkManager: networkManager)
    }
}
