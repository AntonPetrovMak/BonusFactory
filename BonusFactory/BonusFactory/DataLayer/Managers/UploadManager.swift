//
//  UploadManager.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import Foundation
import FirebaseStorage

protocol UploadManager {
    func upload(localFile: URL, progress: ((Double) -> Void)?, completion: @escaping (Result<String, Error>) -> Void)
}

class AppUploadManager: UploadManager {
    
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
            if let error = snapshot.error as? NSError {
                completion(.failure(error))
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                /* ... */
                
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
        
    }
}
