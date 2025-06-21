import SwiftUI
import FirebaseAuth
import Foundation

class RecordViewModel: ObservableObject {
    
    @Published var isRecording = false
    @Published var liveText = ""
    @Published var volumeLevel: Float = 0.0
    @Published var volumeHistory: [Float] = []
    @Published var navigateToDetail: Bool = false
    @Published var lastMemo: Memo? = nil

    private let sttService = STTService()
    private let audioRecorder = AudioRecorder()
    private let openAIService = OpenAIService() // ✅ OpenAI로 교체
    private let firestoreService = FirestoreService()

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        print("🎤 startRecording 진입")
        isRecording = true
        
        audioRecorder.startRecording { [weak self] volume in
            DispatchQueue.main.async {
                self?.volumeLevel = volume
                self?.volumeHistory.append(volume)
                if self?.volumeHistory.count ?? 0 > 100 {
                    self?.volumeHistory.removeFirst()
                }
            }
        }
        
        sttService.startRecognition { [weak self] text in
            DispatchQueue.main.async {
                self?.liveText = text
            }
        }
    }
    
    func stopRecording() {
        print("🛑 stopRecording 진입")
        isRecording = false

        audioRecorder.stopRecording { [weak self] _ in
            guard let self = self else { return }

            self.sttService.stopRecognition()
            let rawText = self.liveText
            print("📝 원본 텍스트: \(rawText)")

            // ✅ OpenAI 요약 요청
            self.openAIService.summarize(text: rawText) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let summary):
                    print("✅ 요약 성공: \(summary)")
                    let title = self.generateTitle(from: summary)

                    self.firestoreService.saveMemo(
                        rawText: rawText,
                        summaryText: summary,
                        title: title
                    ) { result in
                        switch result {
                        case .success():
                            print("✅ Firestore 저장 성공")
                            DispatchQueue.main.async {
                                let now = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy.MM.dd a hh:mm:ss"
                                formatter.locale = Locale(identifier: "ko_KR")
                                let dateString = formatter.string(from: now)

                                self.lastMemo = Memo(
                                    id: UUID().uuidString,
                                    title: title,
                                    summary: summary,
                                    date: dateString,
                                    rawText: rawText
                                )
                                self.navigateToDetail = true
                                print("➡️ 상세 페이지로 이동")
                            }
                        case .failure(let error):
                            print("❌ Firestore 저장 실패: \(error)")
                        }
                    }

                case .failure(let error):
                    print("❌ 요약 실패: \(error)")
                }
            }
        }
    }

    private func generateTitle(from summary: String) -> String {
        return String(summary.prefix(15)) + "..."
    }
}
