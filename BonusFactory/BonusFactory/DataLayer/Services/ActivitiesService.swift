//
//  ActivitiesService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import Combine

protocol ActivitiesService {
    var activities: CurrentValueSubject<[Activity], Never> { get }

    func createActivity(recipientId: String, activity: Activity, _ completion: @escaping ErrorHandler)
}

class AppActivitiesService: ActivitiesService {

    var activities: CurrentValueSubject<[Activity], Never>

    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.activities = .init([])
    }

    fileprivate func subscribeOnActivities(userId: String) {
        networkManager.subscribeOnActivities(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(models):
                self.activities.send(models)
            case let .failure(error):
                Logger.error(error)
            }
        }
    }
    
    func createActivity(recipientId: String, activity: Activity, _ completion: @escaping ErrorHandler) {
        networkManager.addActivity(recipientId: recipientId, activity: activity, completion)
    }
}

extension AppActivitiesService: Sychronizable {
    func authSync(userId: String) {
        subscribeOnActivities(userId: userId)
    }
}
