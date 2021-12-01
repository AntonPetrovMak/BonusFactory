//
//  DataService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 27.11.2021.
//

import Combine

protocol DataService {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { get }
    var currentUser: CurrentValueSubject<Profile?, Never> { get }
}

class AppDataService: DataService {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { dataManager.isLoggedIn }
    var currentUser: CurrentValueSubject<Profile?, Never> { dataManager.currentUser }

    private let dataManager: DataManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.isLoggedIn
            .filter({ $0 == false })
            .sink { [weak self] _ in
                self?.currentUser.send(nil)
            }
            .store(in: &cancellableSet)
    }
}
