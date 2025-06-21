//
//  OpenAIService.swift
//  voiceNote
//
//  Created by 이민주 on 6/21/25.
//

import Foundation

class OpenAIService {
    
    private let apiKey = APIKey.apiKey
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    func summarize(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = """
        다음 한국어 텍스트를 간결하게 요약해줘:

        \(text)
        """

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "당신은 뛰어난 한국어 요약 도우미입니다."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]
        
        guard let url = URL(string: endpoint),
              let body = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "URL 또는 JSON 생성 실패", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 네트워크 에러: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("❌ 응답 데이터 없음")
                completion(.failure(NSError(domain: "데이터 없음", code: 1)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let errorInfo = json["error"] as? [String: Any],
                       let errorMessage = errorInfo["message"] as? String {
                        print("❌ OpenAI API 오류: \(errorMessage)")
                        completion(.failure(NSError(domain: errorMessage, code: 2)))
                        return
                    }

                    if let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        print("✅ 요약 결과: \(content)")
                        completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                        return
                    }
                }

                print("❌ JSON 파싱 실패: 예상과 다른 응답 구조")
                completion(.failure(NSError(domain: "잘못된 JSON 형식", code: 3)))
            } catch {
                print("❌ JSON 디코딩 에러: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

