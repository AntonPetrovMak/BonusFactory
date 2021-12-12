//
//  StorageManager.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import Foundation
import FirebaseStorage

protocol StorageManager {
    func upload(localFile: URL, progress: ((Double) -> Void)?, completion: @escaping (Result<String, Error>) -> Void)
    func download(url: URL, progress: ((Double) -> Void)?, completion: @escaping (Result<Data, Error>) -> Void)
    func delete(url: String, completion: @escaping ErrorHandler)
}

class AppStorageManager: StorageManager {
    
    lazy var storage = Storage.storage()
    lazy var storageRef = storage.reference()
    lazy var newsRef = storageRef.child("news/")
    
    
    init() {
        
    }
    
    /// Upload file
    /// - Parameter localFile: path/to/image
    func upload(localFile: URL, progress: ((Double) -> Void)? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        // Local file you want to upload
        // let localFile = URL(string: localFile)!
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let fileName = "\(UUID().uuidString).jpg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let imagePath = newsRef.child(fileName)
        let uploadTask = imagePath.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress?(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            print(snapshot)
            completion(.success(imagePath.description))
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                completion(.failure(error))
//                switch (StorageErrorCode(rawValue: error.code)!) {
//                case .objectNotFound:
//                    // File doesn't exist
//                    break
//                case .unauthorized:
//                    // User doesn't have permission to access file
//                    break
//                case .cancelled:
//                    // User canceled the upload
//                    break
//
//                /* ... */
//
//                case .unknown:
//                    // Unknown error occurred, inspect the server response
//                    break
//                default:
//                    // A separate error occurred. This is a good place to retry the upload.
//                    break
//                }
            }
        }
        
    }
    
    func download(url: URL, progress: ((Double) -> Void)? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        // Create a reference to the file we want to download
        let gsReference = storage.reference(forURL: url.absoluteString)
        
        // Start the download (in this case writing to a file)
        let downloadTask = gsReference.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(BFError.somethingWentWrong))
            }
        }
        
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
            // Download resumed, also fires when the download starts
        }
        
        downloadTask.observe(.pause) { snapshot in
            // Download paused
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress?(percentComplete)
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
        }
        
        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let nsError = snapshot.error as NSError? else {
                return completion(.failure(BFError.somethingWentWrong))
            }
            completion(.failure(nsError))

//            let errorCode = nsError.code
//            guard let error = StorageErrorCode(rawValue: errorCode) else { return }
//            switch (error) {
//            case .objectNotFound:
//                // File doesn't exist
//                break
//            case .unauthorized:
//                // User doesn't have permission to access file
//                break
//            case .cancelled:
//                // User cancelled the download
//                break
//
//            /* ... */
//
//            case .unknown:
//                // Unknown error occurred, inspect the server response
//                break
//            default:
//                // Another error occurred. This is a good place to retry the download.
//                break
//            }
        }
    }

    func delete(url: String, completion: @escaping ErrorHandler) {
        let gsReference = storage.reference(forURL: url)
        gsReference.delete(completion: completion)
    }
}
