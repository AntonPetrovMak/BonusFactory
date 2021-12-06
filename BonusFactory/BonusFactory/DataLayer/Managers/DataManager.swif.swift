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
    var profile: CurrentValueSubject<Profile?, Never> { get }
}

class AppDataManager: DataManager {
    var isLoggedIn: CurrentValueSubject<Bool?, Never>
    var userId: String?
    var profile: CurrentValueSubject<Profile?, Never>
    
    init() {
        self.isLoggedIn = .init(nil)
        self.profile = .init(nil)
    }
}
