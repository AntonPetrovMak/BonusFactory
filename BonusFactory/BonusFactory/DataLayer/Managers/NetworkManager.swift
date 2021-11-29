//
//  NetworkManager.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import FirebaseFirestore

protocol NetworkManager {
    func createMockOrdanization()
    func addOrdanizationListener(_ completion: @escaping (Result<Organization, Error>) -> Void)
    func addUserListener(id: String, completion: @escaping (Result<BFUser, Error>) -> Void)
}

class AppNetworkManager: NetworkManager {

    private lazy var db: Firestore = {
        return Firestore.firestore()
    }()

    private lazy var users: CollectionReference = {
        return self.db.collection("users")
    }()

    private lazy var organizationRef: CollectionReference = {
        return self.db.collection("organization")
    }()

    private lazy var currentOrganzationRef: DocumentReference = {
        return self.organizationRef.document("coffee_shop")
    }()

    // MARK: - Public Methods
    func addOrdanizationListener(_ completion: @escaping (Result<Organization, Error>) -> Void) {
        currentOrganzationRef.addModelListener(completion)
    }

    func addUserListener(id: String, completion: @escaping (Result<BFUser, Error>) -> Void) {
        users
            .document(id)
            .addModelListener(completion)
    }

    func createMockOrdanization() {
        let name = "Coffee Shop"
        let docmentId = "coffee_shop"
        let paragraphs = [
            Paragraphs(title: "Abount Coffee Shop",
                       text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                       order: 0)
        ]

        let about = About(name: name, paragraphs: paragraphs, logo: "")
        
        let links = [
            ContactLink(type: .website, url: "www.google.com"),
            ContactLink(type: .instagram, url: "www.google.com"),
            ContactLink(type: .facebook, url: "www.google.com")
        ]
        
        let phones = [
            "+380998887766"
        ]

        let institutions = [
            Institution(latitude: 50.487043, longitude: 30.515698),
            Institution(latitude: 51.487043, longitude: 30.315698)
        ]

        let staff = [
            Staff(position: .owner, userId: "id1"),
            Staff(position: .admin, userId: "id1"),
            Staff(position: .teller, userId: "id1")
        ]

        let org = Organization(abount: about, links: links, phones: phones, institutions: institutions, staff: staff)

        guard let data = org.encodeParameters else {
            Logger.print("Error decode organization model !")
            return
        }
        organizationRef
            .document(docmentId)
            .setData(data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: ")
                }
            }
    }
}

// MARK: - Error
enum BFError: Error, LocalizedError {
    case somethingWentWrong
    case noOrganizations
    
    public var errorDescription: String? {
      switch self {
      case .somethingWentWrong,
           .noOrganizations:
        return "Something Went Wrong"
      }
    }
}

// MARK: - Print Extensions
extension DocumentReference {
    static private func modelHandler<T: Codable>(snapshot: DocumentSnapshot?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let snapshot = snapshot,
           let model = T.init(from: snapshot.data()) {
            Logger.print("✅Path: \(snapshot.documentID)")
            Logger.print("Snapshot: \n\(model.printDescription())")
            completion(.success(model))
        } else if let error = error {
            Logger.print("❌Path: \(snapshot?.documentID ?? "???")")
            Logger.print("Error: \(error.localizedDescription)")
            completion(.failure(error))
        } else {
            Logger.print("❌Path: \(snapshot?.documentID ?? "???")")
            Logger.print("Error: no error")
            completion(.failure(BFError.somethingWentWrong))
        }
    }
    
    func addModelListener<T: Codable>(_ completion: @escaping (Result<T, Error>) -> Void) {
        addSnapshotListener(includeMetadataChanges: false) { (document, error) in
            Self.modelHandler(snapshot: document, error: error, completion: completion)
        }
    }
}

extension CollectionReference {
    
    static private func modelsHandler<T: Codable>(snapshot: QuerySnapshot?, error: Error?, completion: @escaping (Result<[T], Error>) -> Void) {
        if let snapshot = snapshot {
            let models: [T] = snapshot.documents.compactMap { T.init(from: $0.data()) }
            Logger.print("✅Snapshot: \n\(models.printDescription())")
            completion(.success(models))
        } else if let error = error {
            Logger.print("❌Error: \(error.localizedDescription)")
            completion(.failure(error))
        } else {
            Logger.print("❌Error: no error")
            completion(.failure(BFError.somethingWentWrong))
        }
    }
    
    func getModels<T: Codable>(_ completion: @escaping (Result<[T], Error>) -> Void) {
        getDocuments(completion: { (snapshot, error) in
            Self.modelsHandler(snapshot: snapshot, error: error, completion: completion)
        })
    }

    func addModelsListener<T: Codable>(_ completion: @escaping (Result<[T], Error>) -> Void) {
        addSnapshotListener { (snapshot, error) in
            Self.modelsHandler(snapshot: snapshot, error: error, completion: completion)
        }
    }
}
