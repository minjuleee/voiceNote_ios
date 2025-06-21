import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    private let db = Firestore.firestore()
    
    // 🔐 현재 로그인된 사용자 UID 가져오기
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    // MARK: - 메모 저장
    func saveMemo(rawText: String,
                  summaryText: String,
                  title: String,
                  completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = currentUserId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 정보 없음"])))
            return
        }

        let memoData: [String: Any] = [
            "title": title,
            "dateTime": Timestamp(date: Date()),
            "rawText": rawText,
            "summary": summaryText
        ]
        
        db.collection("users")
            .document(userId)
            .collection("memos")
            .addDocument(data: memoData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    // MARK: - 메모 불러오기
    func fetchMemos(completion: @escaping ([Memo]) -> Void) {
        guard let userId = currentUserId else {
            completion([])
            return
        }

        db.collection("users")
            .document(userId)
            .collection("memos")
            .order(by: "dateTime", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ 메모 불러오기 실패: \(error?.localizedDescription ?? "알 수 없음")")
                    completion([])
                    return
                }
                
                let memos: [Memo] = documents.compactMap { doc in
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let summary = data["summary"] as? String,
                          let rawText = data["rawText"] as? String,
                          let timestamp = data["dateTime"] as? Timestamp else {
                        return nil
                    }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd a hh:mm:ss"
                    formatter.locale = Locale(identifier: "ko_KR")
                    let dateString = formatter.string(from: timestamp.dateValue())
                    
                    return Memo(
                        id: doc.documentID,
                        title: title,
                        summary: summary,
                        date: dateString,
                        rawText: rawText
                    )
                }
                
                completion(memos)
            }
    }
    
    // MARK: - Firestore만 메모 삭제
    func deleteMemo(memoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = currentUserId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 정보 없음"])))
            return
        }

        db.collection("users")
            .document(userId)
            .collection("memos")
            .document(memoId)
            .delete { error in
                if let error = error {
                    print("❌ Firestore 삭제 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("✅ 메모 삭제 성공")
                    completion(.success(()))
                }
            }
    }
}
