//
//  LoginViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine

class LoginViewModel: LoginVMP {
    @Published var phone: String = ""
    
    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func onNext() {
        Logger.print("Phone: \(phone)")
        services.authService.login(phone: phone) { error in
            Logger.print("Error: \(error.debugDescription)")
        }
    }
}
