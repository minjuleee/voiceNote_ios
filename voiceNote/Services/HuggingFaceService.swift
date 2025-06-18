//
//  HuggingFaceService.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Foundation

class HuggingFaceService {
    
    private let apiKey = "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"  // 👉 여기에 본인 키 넣기
    private let endpoint = "https://api-inference.huggingface.co/models/facebook/bart-large-cnn"
    
    func summarize(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let parameters: [String: Any] = ["inputs": text]
        guard let url = URL(string: endpoint),
              let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NSError(domain: "URL or JSON Error", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0)))
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                let summary = result?.first?["summary_text"] as? String ?? "요약 실패"
                completion(.success(summary))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

