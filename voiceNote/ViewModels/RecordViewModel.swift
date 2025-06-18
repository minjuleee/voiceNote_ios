//
//  RecordViewModel.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

class RecordViewModel: ObservableObject {
    
    @Published var isRecording = false
    @Published var liveText = ""
    @Published var volumeLevel: Float = 0.0
    
    private let sttService = STTService()
    private let audioRecorder = AudioRecorder()
    private let huggingFaceService = HuggingFaceService()
    private let storageService = StorageService()
    private let firestoreService = FirestoreService()
    
    private let userId = "test"  // (실제 로그인 uid 사용)
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        isRecording = true
        audioRecorder.startRecording { [weak self] volume in
            DispatchQueue.main.async {
                self?.volumeLevel = volume
            }
        }
        sttService.startRecognition { [weak self] text in
            DispatchQueue.main.async {
                self?.liveText = text
            }
        }
    }
    
    func stopRecording() {
        isRecording = false
        audioRecorder.stopRecording { [weak self] fileURL in
            guard let self = self, let fileURL = fileURL else { return }
            guard let audioData = try? Data(contentsOf: fileURL) else { return }
            
            self.huggingFaceService.summarize(text: self.liveText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let summary):
                    let title = self.generateTitle(from: summary)
                    let fileName = UUID().uuidString
                    
                    self.storageService.uploadAudio(fileName: fileName, audioData: audioData) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let audioUrl):
                            self.firestoreService.saveMemo(userId: self.userId, audioUrl: audioUrl, rawText: self.liveText, summaryText: summary, title: title) { result in
                                switch result {
                                case .success():
                                    print("저장 완료")
                                case .failure(let error):
                                    print("저장 실패: \(error)")
                                }
                            }
                        case .failure(let error):
                            print("Storage 실패: \(error)")
                        }
                    }
                    
                case .failure(let error):
                    print("요약 실패: \(error)")
                }
            }
        }
        
        sttService.stopRecognition()
    }
    
    private func generateTitle(from summary: String) -> String {
        return String(summary.prefix(15)) + "..."
    }
}
