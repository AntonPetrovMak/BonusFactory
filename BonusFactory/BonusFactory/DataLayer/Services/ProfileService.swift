//
//  ProfileService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol ProfileService {
    //func syncCurrentUser(_ id: String)
}

class AppProfileService: ProfileService {
    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
//        self.dataManager.isLoggedIn
//            .filter({ $0 == true })
//            .sink { [weak self] _ in
//                guard let self = self,
//                      let userId = self.dataManager.userId else { return }
//                self.syncCurrentUser(userId)
//            }
//            .store(in: &cancellableSet)
    }
//
//    fileprivate func syncCurrentUser(_ id: String) {
//        getProfile(id: id)
//    }

    fileprivate func getProfile(id: String) {
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
        getProfile(id: userId)
    }
    
}
