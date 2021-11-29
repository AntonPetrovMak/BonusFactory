//
//  DashboardViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation
import Combine

class DashboardViewModel: DashboardVMP {

    @Published var points: String = ""
    
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()

    init(services: Services) {
        self.services = services
        self.services.dataService.currentUser
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.points = Int(user.points).description
            }
            .store(in: &cancellableSet)
    }
}

