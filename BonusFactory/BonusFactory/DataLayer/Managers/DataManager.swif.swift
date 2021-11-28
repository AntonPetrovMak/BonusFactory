//
//  DataManager.swif.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol DataManager {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { get }
}

class AppDataManager: DataManager {
    var isLoggedIn: CurrentValueSubject<Bool?, Never>
    
    init() {
        self.isLoggedIn = .init(nil)
    }
}
