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
        self.dataService = AppDataService(dataManager: dataManager)
        
        let appProfileService = AppProfileService(dataManager: dataManager, networkManager: networkManager)
        self.profileService = appProfileService

        self.organizationService = AppOrganizationService(dataManager: dataManager, networkManager: networkManager)
        
        let appNewsService = AppNewsService(dataManager: dataManager, networkManager: networkManager)
        self.newsService = appNewsService
        
        let syncServices: [Sychronizable] = [appProfileService, appNewsService]
        self.authService = AppAuthService(dataManager: dataManager, syncServices: syncServices)
    }
}

protocol Sychronizable {
    func authSync(userId: String)
}
