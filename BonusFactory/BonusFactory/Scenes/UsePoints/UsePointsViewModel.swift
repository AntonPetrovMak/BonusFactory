//
//  UsePointsViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 06.12.2021.
//

import Foundation
import Combine

class UsePointsViewModel: UsePointsSceneVMP {

    @Published private(set) var userName: String = ""
    @Published private(set) var totalPoints: String = ""
    @Published var selectedIndex: Int = 0
    @Published var amount: String = "0"
    @Published private(set) var isLoadingButton: Bool = false

    private(set) var simulatedData: String?
    @Published var scannedCode: String?
    @Published private(set) var isLoadingUser: Bool = false
    
    // MARK: - Private Properties
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()
    private var customerProfile: Profile?

    init(services: Services) {
        self.services = services
        #if targetEnvironment(simulator)
        simulatedData = "Test user id"
        #endif
        bind()
    }
    
    // MARK: - Private Methods
    private func bind() {
        $scannedCode
            .compactMap { $0 }
            .sink { [weak self] code in
                guard let self = self else { return }
                self.loadUserData(id: code)
            }
            .store(in: &cancellableSet)
    }

    private func loadUserData(id: String) {
        isLoadingUser = true
        services.profileService.fetchProfile(id: id) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingUser = false

            switch result {
            case let .success(profile):
                self.customerProfile = profile
                self.userName = profile.fullname
                self.totalPoints = "\(profile.points)"
            case let .failure(error):
                Logger.error(error)
                self.scannedCode = nil
            }
        }
    }

    // MARK: - Public Methods
    func onNext() {
        guard let customerProfile = customerProfile,
              let amountInt = Int(amount)
        else { return }

        let completion: ErrorHandler = { [weak self] error in
            Logger.error(error)
            self?.isLoadingButton = false
            self?.customerProfile = nil
            self?.scannedCode = nil
        }

        self.isLoadingButton = true
        if selectedIndex == 0 {
            services.profileService.addPoints(profile: customerProfile, amount: amountInt, completion: completion)
        } else {
            services.profileService.withdrawPoints(profile: customerProfile, amount: amountInt, completion: completion)
        }
    }
}

