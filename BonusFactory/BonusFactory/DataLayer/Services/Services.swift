//
//  Services.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation

protocol Services {
    var authService: AuthService { get }
    var dataService: DataService { get }
    var userService: UserService { get }
    var organizationService: OrganizationService { get }
}

class AppServices: Services {
    let authService: AuthService
    let dataService: DataService
    let userService: UserService
    var organizationService: OrganizationService

    init() {
        let networkManager = AppNetworkManager()
        let dataManager = AppDataManager()
        self.dataService = AppDataService(dataManager: dataManager)
        self.authService = AppAuthService(dataManager: dataManager)
        self.userService = AppUserService(dataManager: dataManager, networkManager: networkManager)
        self.organizationService = AppOrganizationService(dataManager: dataManager, networkManager: networkManager)
    }
}
