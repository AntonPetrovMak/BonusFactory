//
//  ProfileService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol ProfileService {
    
}

class AppProfileService: ProfileService {
    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
    }

    fileprivate func subscribeOnProfile(id: String) {
        networkManager.subscribeOnProfile(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.dataManager.currentUser.send(model)
            case .failure:
                break
            }
        }
    }
}

// MARK: - Sychronizable
extension AppProfileService: Sychronizable {
    func authSync(userId: String) {
        subscribeOnProfile(id: userId)
    }
    
}
