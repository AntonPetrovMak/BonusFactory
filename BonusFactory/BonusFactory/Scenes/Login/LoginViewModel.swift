//
//  LoginViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation

import Foundation
import Combine

class LoginViewModel: ViewModel {
    @Published var state: LoginState
    
    private let services: Services
    private let router: Router
    
    init(services: Services, router: Router) {
        self.services = services
        self.router = router
        state = .init()
    }

    func trigger(_ event: LoginEvent) {

    }
}
