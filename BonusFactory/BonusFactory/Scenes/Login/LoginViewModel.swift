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
    private let router: LoginRouterProtocol

    init(services: Services, router: LoginRouterProtocol) {
        self.services = services
        self.router = router
        #if targetEnvironment(simulator)
        phone = "+380939858899"
        #endif
    }

    func onNext() {
        Logger.print("Phone: \(phone)")
        services.authService.auth(phone: phone) { error in
            if let error = error {
                Logger.print("Error: \(error.localizedDescription)")
            } else {
                self.router.showConfirmScene()
            }
        }
    }
}
