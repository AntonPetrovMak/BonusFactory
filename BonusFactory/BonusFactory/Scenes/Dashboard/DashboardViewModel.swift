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
    @Published var userName: String = ""
    @Published var companyName: String = ""
    
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()

    init(services: Services) {
        self.services = services
        self.services.dataService.currentUser
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.points = Int(user.points).description
                self?.userName = user.name
            }
            .store(in: &cancellableSet)

        self.services.organizationService.organization
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] organization in
                self?.companyName = organization.abount.name
            }
            .store(in: &cancellableSet)
    }
}

