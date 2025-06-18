//
//  StorageService.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import FirebaseStorage
import Foundation

class StorageService {
    
    private let storage = Storage.storage()
    
    func uploadAudio(fileName: String, audioData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("audioFiles/\(fileName).m4a")
        
        storageRef.putData(audioData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(NSError(domain: "URL Error", code: 0)))
                }
            }
        }
    }
}


