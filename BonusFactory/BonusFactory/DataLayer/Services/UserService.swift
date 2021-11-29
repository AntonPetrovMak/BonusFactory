//
//  UserService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Combine
import FirebaseFirestore

protocol UserService {
    func syncCurrentUser(_ id: String)
}

class AppUserService: UserService {

    private lazy var db: Firestore = {
        return Firestore.firestore()
    }()

    private lazy var users: CollectionReference = {
        return self.db.collection("users")
    }()

    private let dataManager: DataManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.dataManager.isLoggedIn
            .filter({ $0 == true })
            .sink { [weak self] _ in
                guard let self = self,
                      let userId = self.dataManager.userId else { return }
                self.syncCurrentUser(userId)
            }
            .store(in: &cancellableSet)
        //createUser(userId: UUID().uuidString, phone: "+380939858893")
        //readUsers()
    }

    func readUsers() {
        users.document("")
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

    func syncCurrentUser(_ id: String) {
        getUser(id: id)
    }
    
    func getUser(id: String) {
        users
            .document(id)
            .getDocument { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let querySnapshot = querySnapshot {
                    if let data = querySnapshot.data(),
                       let user = BFUser(from: data) {
                        self.dataManager.currentUser.send(user)
                    }
                } else if let error = error {
                    self.dataManager.currentUser.send(nil)
                    Logger.print("❌ \(error.localizedDescription)")
                } else {
                    self.dataManager.currentUser.send(nil)
                    Logger.print("❌ No data")
                }
            }
    }

    func createUser(userId: String, phone: String) {
        let data: [String: Any] =  [
            "id": userId,
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
}
