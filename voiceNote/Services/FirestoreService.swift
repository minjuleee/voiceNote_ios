//
//  FirestoreService.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import FirebaseFirestore

class FirestoreService {
    
    private let db = Firestore.firestore()
    
    func saveMemo(userId: String, audioUrl: String, rawText: String, summaryText: String, title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let memoData: [String: Any] = [
            "title": title,
            "dateTime": Timestamp(date: Date()),
            "rawText": rawText,
            "summary": summaryText,
            "audioUrl": audioUrl
        ]
        
        db.collection("users").document(userId).collection("memos").addDocument(data: memoData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


