//
//  DataManager.swif.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine

protocol DataManager {
    var isLoggedIn: CurrentValueSubject<Bool?, Never> { get }
    var userId: String? { get set }
    var currentUser: CurrentValueSubject<Profile?, Never> { get }
}

class AppDataManager: DataManager {
    var isLoggedIn: CurrentValueSubject<Bool?, Never>
    var userId: String?
    var currentUser: CurrentValueSubject<Profile?, Never>
    
    init() {
        self.isLoggedIn = .init(nil)
        self.currentUser = .init(nil)
    }
}
