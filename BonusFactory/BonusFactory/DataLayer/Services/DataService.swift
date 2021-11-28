//
//  DataService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 27.11.2021.
//

import Combine

protocol DataService {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { get }
}

class AppDataService: DataService {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { dataManager.isLoggedIn }

    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
