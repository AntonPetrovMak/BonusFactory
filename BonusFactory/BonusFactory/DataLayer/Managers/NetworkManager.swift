//
//  NetworkManager.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Foundation
import FirebaseFirestore

protocol NetworkManager {
    func getProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func createProfile(profile: Profile, completion: @escaping ErrorHandler)
    func subscribeOnProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void)

    func subscribeOnNews(_ completion: @escaping (Result<[News], Error>) -> Void)
    func addNews(_ news: News, _ completion: @escaping ErrorHandler)

    func createMockOrdanization(_ completion: ErrorHandler?)
    func subscribeOnOrdanization(_ completion: @escaping (Result<Organization, Error>) -> Void)
}

class AppNetworkManager: NetworkManager {

    // MARK: - References
    private lazy var db: Firestore = {
        return Firestore.firestore()
    }()

    private lazy var usersRef: CollectionReference = {
        return self.db.collection("users")
    }()

    private lazy var organizationRef: CollectionReference = {
        return self.db.collection("organization")
    }()

    private lazy var currentOrganzationRef: DocumentReference = {
        return self.organizationRef.document("coffee_shop")
    }()

    private lazy var newsRef: CollectionReference = {
        return self.db.collection("news")
    }()

    // MARK: - Public Methods
    // MARK: - Profile
    func getProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        usersRef
            .document(id)
            .getModelDocumnet(completion)
    }

    func createProfile(profile: Profile, completion: @escaping ErrorHandler) {
        guard let data = profile.encodeParameters else {
            completion(BFError.encodeModel)
            return
        }
        usersRef
            .document(profile.id)
            .setData(data, completion: completion)

    }

    func subscribeOnProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        usersRef
            .document(id)
            .addModelListener(completion)
    }

    // MARK: - News
    func subscribeOnNews(_ completion: @escaping (Result<[News], Error>) -> Void) {
        newsRef.addModelsListener(completion)
    }

    func addNews(_ news: News, _ completion: @escaping ErrorHandler) {
        guard let data = news.encodeParameters else {
            completion(BFError.encodeModel)
            return
        }
        newsRef.addDocument(data: data, completion: completion)
    }
    
    // MARK: - Ordanization
    func subscribeOnOrdanization(_ completion: @escaping (Result<Organization, Error>) -> Void) {
        currentOrganzationRef.addModelListener(completion)
    }

    func createMockOrdanization(_ completion: ErrorHandler? = nil) {
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
            completion?(BFError.encodeModel)
            return
        }

        organizationRef
            .document(docmentId)
            .setData(data, completion: completion)
        
    }
}

// MARK: - Error
enum BFError: Error, LocalizedError {
    case somethingWentWrong
    case noOrganizations
    case encodeModel
    case decodeModel
    
    public var errorDescription: String? {
      switch self {
      case .somethingWentWrong,
           .noOrganizations,
           .encodeModel,
           .decodeModel:
        return "Something Went Wrong"
      }
    }
}

// MARK: - Print Extensions
extension DocumentReference {
    static private func modelHandler<T: Codable>(snapshot: DocumentSnapshot?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let snapshot = snapshot,
           let model = T.init(from: snapshot.data()) {
            Logger.print("✅Snapshot: \n\(model.printDescription())")
            completion(.success(model))
        } else if let error = error {
            Logger.print("❌Error: \(error.localizedDescription)")
            completion(.failure(error))
        } else {
            Logger.print("❌Error: decode model error")
            completion(.failure(BFError.decodeModel))
        }
    }
    
    func addModelListener<T: Codable>(_ completion: @escaping (Result<T, Error>) -> Void) {
        addSnapshotListener(includeMetadataChanges: false) { (document, error) in
            Self.modelHandler(snapshot: document, error: error, completion: completion)
        }
    }

    func getModelDocumnet<T: Codable>(_ completion: @escaping (Result<T, Error>) -> Void) {
        getDocument { (document, error) in
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
            Logger.print("❌Error: decode models error")
            completion(.failure(BFError.decodeModel))
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

    func getModelsDocumnet<T: Codable>(_ completion: @escaping (Result<[T], Error>) -> Void) {
        getDocuments { (snapshot, error) in
            Self.modelsHandler(snapshot: snapshot, error: error, completion: completion)
        }
    }
}
