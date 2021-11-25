//
//  LaunchViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine

class LaunchViewModel: ObservableObject {
    @Published var isLoading = true
    
    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func trigger(_ event: LaunchEvent) {
        switch event {
        case .onLogin:
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                self?.isLoading = false
            }
        }
    }
}
