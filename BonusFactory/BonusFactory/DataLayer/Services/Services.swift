//
//  Services.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation

class Services {
    
    static let shared = Services()
    
    let authService: AuthService
    
    private init() {
        authService = AuthService()
    }

    func configServices() {
        
    }
}
