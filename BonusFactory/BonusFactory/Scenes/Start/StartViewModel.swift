//
//  StartViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine

class StartViewModel: ViewModel {
    @Published var state: StartState
    
    private let services: Services
    private let router: Router
    
    init(services: Services, router: Router) {
        self.services = services
        self.router = router
        state = .init(isLoading: false)
    }

    func trigger(_ event: StartEvent) {
        switch event {
        case .onLogin:
            state.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    self.router.push(.login)
                }
            }
        }
    }
}
