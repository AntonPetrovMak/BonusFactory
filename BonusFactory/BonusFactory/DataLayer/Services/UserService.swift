//
//  UserService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation
import FirebaseFirestore

protocol UserService {

}

class AppUserService: UserService {

    private lazy var db: Firestore = {
        return Firestore.firestore()
    }()

    private lazy var users: CollectionReference = {
        return self.db.collection("users")
    }()

    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        //createUser(userId: UUID().uuidString, phone: "+380939858893")
        //readUsers()
    }

    func readUsers() {
        users.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.readUsers()
        }
    }

    func createUser(userId: String, phone: String) {
        let data: [String: Any] =  [
            "first": "",
            "phone": phone,
            "points": 10
        ]
        users
            .document(userId)
            .setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: ")
            }
        }
    }

    func writeUser2() {
        db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: ")
            }
        }
    }
}
