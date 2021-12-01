//
//  AuthManager.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import FirebaseAuth

protocol AuthManager {
    func auth(phone: String, completion: @escaping (Result<String, Error>) -> Void)
    func signIn(verificationId: String, code: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void)
    func signOut() throws
}

class AppAuthManager: AuthManager {
    
    func auth(phone: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
                if let verificationID = verificationID {
                    completion(.success(verificationID))
                } else {
                    completion(.failure(error ?? BFError.somethingWentWrong))
                }
            }
    }
    
    func signIn(verificationId: String, code: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: code
        )

        Auth.auth().signIn(with: credential) { (result, error) in
            if let result = result {
                completion(.success(result.user))
            } else {
                completion(.failure(error ?? BFError.somethingWentWrong))
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError as NSError {
//            Logger.print("Error signing out: \(signOutError)")
//        }
    }
}
