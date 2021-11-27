//
//  ConfirmSMSViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import Foundation

import Foundation
import Combine

class ConfirmSMSViewModel: ConfirmSMSVMP {
    @Published var code: String = ""
    
    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func onNext() {
        Logger.print("Code: \(code)")
        services.authService.verifyCode(code: code) { error in
            Logger.print("Error: \(error.debugDescription)")
        }
    }
}
