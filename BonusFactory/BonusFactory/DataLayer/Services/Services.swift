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
    var profileService: ProfileService { get }
    var organizationService: OrganizationService { get }
    var newsService: NewsService { get }
}

class AppServices: Services {
    let authService: AuthService
    let dataService: DataService
    let profileService: ProfileService
    var organizationService: OrganizationService
    var newsService: NewsService

    init() {
        let networkManager = AppNetworkManager()
        let dataManager = AppDataManager()
        let authManager = AppAuthManager()
        self.dataService = AppDataService(dataManager: dataManager)
        
        let appProfileService = AppProfileService(dataManager: dataManager, networkManager: networkManager)
        self.profileService = appProfileService

        let appOrganizationService = AppOrganizationService(dataManager: dataManager, networkManager: networkManager)
        self.organizationService = appOrganizationService
        
        let appNewsService = AppNewsService(dataManager: dataManager, networkManager: networkManager)
        self.newsService = appNewsService
        
        let syncServices: [Sychronizable] = [appProfileService, appNewsService, appOrganizationService]
        self.authService = AppAuthService(dataManager: dataManager,
                                          authManager: authManager,
                                          networkManager: networkManager,
                                          syncServices: syncServices)
    }
}

protocol Sychronizable {
    func authSync(userId: String)
}
