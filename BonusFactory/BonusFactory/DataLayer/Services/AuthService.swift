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
    
    private var verificationId: String?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func fetchCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            Logger.print("Current user: \(currentUser)")
            self.dataManager.isLoggedIn.send(true)
        } else {
            self.dataManager.isLoggedIn.send(false)
        }
    }
    
    func auth(phone: String, completion: @escaping ErrorHandler) {
        //return completion(nil)
        
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+380939858899", uiDelegate: nil) { verificationID, error in
                if let verificationID = verificationID {
                    Logger.print("VerificationID: \(verificationID)")
                    self.verificationId = verificationID
                    completion(nil)
                } else {
                    completion(error)
                    //Logger.print("Error: \(error.debugDescription)")
                }
            }
    }
    
    func verifyCode(code: String, completion: @escaping ErrorHandler) {
        //self.isLoggedIn.send(true)
        //return completion(nil)
        
        guard let verificationId = verificationId else {
            return completion(nil)
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: "000000"
        )
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let result = result {
                Logger.print("Result: \(result)")
                Logger.print("Uid: \(result.user.uid)")
                self.dataManager.isLoggedIn.send(true)
                completion(nil)
            } else {
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
}
