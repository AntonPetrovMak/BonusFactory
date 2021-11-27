//
//  DataService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 27.11.2021.
//

import Foundation
import FirebaseFirestore

protocol DataService {

}

class AppDataService: DataService {

    private var db: Firestore = {
        return Firestore.firestore()
    }()
    
    init() {
        
        
        
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

}
