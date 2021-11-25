//
//  AuthService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation

protocol AuthService {
    var isLoggedIn: Bool { get }
}

class AppAuthService: AuthService {
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    var isLoggedIn: Bool {
        return true
    }
}
