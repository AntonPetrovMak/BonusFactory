//
//  AuthService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine
import FirebaseAuth

typealias VoidHandler = () -> Void
typealias ErrorHandler = (Error?) -> Void

protocol AuthService {
    func auth(phone: String, completion: @escaping ErrorHandler)
    func verifyCode(code: String, completion: @escaping ErrorHandler)
    
    func fetchCurrentUser()
    func signOut()
}

class AppAuthService: AuthService {
    
    private var dataManager: DataManager
    private var authManager: AuthManager
    private var networkManager: NetworkManager
    private var syncServices: [Sychronizable]
    private var verificationId: String?
    
    init(dataManager: DataManager, authManager: AuthManager, networkManager: NetworkManager, syncServices: [Sychronizable]) {
        self.dataManager = dataManager
        self.authManager = authManager
        self.networkManager = networkManager
        self.syncServices = syncServices
    }
    
    func fetchCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            Logger.print("Current user: \(currentUser)")
            dataManager.userId = currentUser.uid
            dataManager.isLoggedIn.send(true)
            startSyncOfServices(userId: currentUser.uid)
        } else {
            dataManager.isLoggedIn.send(false)
        }
    }
    
    func auth(phone: String, completion: @escaping ErrorHandler) {
        //return completion(nil)
        
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        authManager.auth(phone: "+380939858899") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(verificationID):
                self.verificationId = verificationID
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    func verifyCode(code: String, completion: @escaping ErrorHandler) {
        //self.isLoggedIn.send(true)
        //return completion(nil)
        
        guard let verificationId = verificationId else {
            return completion(nil)
        }
        
        authManager.signIn(verificationId: verificationId, code: "000000") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(authUser):
                self.createProfileIfNeeded(authUser.uid, authUser.phoneNumber) { [weak self] error in
                    if let error = error {
                        completion(error)
                    } else {
                        self?.fetchCurrentUser()
                        completion(nil)
                    }
                }
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            dataManager.isLoggedIn.send(false)
        } catch let signOutError as NSError {
            Logger.print("Error signing out: \(signOutError)")
        }
    }

    // MARK: - Private
    private func createProfileIfNeeded(_ userId: String, _ phone: String?, completion: @escaping ErrorHandler) {
        networkManager.getProfile(id: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                completion(nil)
            case let .failure(error):
                Logger.error(error)
                let profile = Profile(id: userId, phone: phone ?? "")
                self.networkManager.createProfile(profile: profile, completion: completion)
            }
        }
    }
    
    private func startSyncOfServices(userId: String) {
        syncServices.forEach { $0.authSync(userId: userId) }
    }
}
