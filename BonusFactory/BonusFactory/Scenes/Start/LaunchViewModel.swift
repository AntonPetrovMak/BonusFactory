//
//  LaunchViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine

class LaunchViewModel: ObservableObject {
    private let services: Services

    init(services: Services) {
        self.services = services
        self.services.authService.fetchCurrentUser()
    }
}
