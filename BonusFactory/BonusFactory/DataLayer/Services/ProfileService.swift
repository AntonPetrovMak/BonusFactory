//
//  ProfileService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol ProfileService {
    func fetchProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func addPoints(profile: Profile, amount: Int, completion: @escaping ErrorHandler)
    func withdrawPoints(profile: Profile, amount: Int, completion: @escaping ErrorHandler)
}

class AppProfileService: ProfileService {
    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
    }

    func fetchProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        networkManager.getProfile(id: id, completion: completion)
    }

    func updatePoints(userId: String, amount: Int, completion: @escaping ErrorHandler) {
        networkManager.updatePoints(userId: userId, amount: amount, completion: completion)
    }

    func addPoints(profile: Profile, amount: Int, completion: @escaping ErrorHandler) {
        let newAmount = profile.points + amount
        networkManager.updatePoints(userId: profile.id, amount: newAmount, completion: completion)
    }

    func withdrawPoints(profile: Profile, amount: Int, completion: @escaping ErrorHandler) {
        let newAmount = profile.points - amount
        networkManager.updatePoints(userId: profile.id, amount: newAmount, completion: completion)
    }
    
    fileprivate func subscribeOnProfile(id: String) {
        networkManager.subscribeOnProfile(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.dataManager.profile.send(model)
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
