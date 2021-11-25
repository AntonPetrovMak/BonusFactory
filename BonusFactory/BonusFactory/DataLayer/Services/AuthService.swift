//
//  AuthService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import Combine

typealias VoidHandler = () -> Void
typealias ErrorHandler = (Error?) -> Void

protocol AuthService {
    var isLoggedIn: CurrentValueSubject<Bool, Never> { get }
    
    func login(phone: String, completion: @escaping ErrorHandler)
}

class AppAuthService: AuthService {
    
    var isLoggedIn: CurrentValueSubject<Bool, Never>
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.isLoggedIn = .init(false)
    }

    func login(phone: String, completion: @escaping ErrorHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoggedIn.send(true)
            completion(nil)
        }
    }
}
