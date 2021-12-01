//
//  OrganizationService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol OrganizationService {
    var organization: CurrentValueSubject<Organization, Never> { get }
}

class AppOrganizationService: OrganizationService {

    var organization: CurrentValueSubject<Organization, Never> = .init(.empty)
    
    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
    }

   fileprivate func syncOrdanization() {
        networkManager.subscribeOnOrdanization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.organization.send(model)
            case .failure:
                break
            }
        }
    }
}

extension AppOrganizationService: Sychronizable {
    func authSync(userId: String) {
        syncOrdanization()
    }
}
