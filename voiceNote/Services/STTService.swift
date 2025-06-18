//
//  STTService.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Speech

class STTService {
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
    
    func startRecognition(updateHandler: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                self.startSession(updateHandler: updateHandler)
            } else {
                print("STT 권한 거부됨")
            }
        }
    }
    
    private func startSession(updateHandler: @escaping (String) -> Void) {
        request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        recognizer?.recognitionTask(with: request!) { result, error in
            if let result = result {
                updateHandler(result.bestTranscription.formattedString)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopRecognition() {
        request?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}


