import Speech
import AVFoundation

class STTService {
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?

    func startRecognition(updateHandler: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                DispatchQueue.main.async {
                    self.startSession(updateHandler: updateHandler)
                }
            } else {
                print("❌ STT 권한 거부됨")
            }
        }
    }

    private func startSession(updateHandler: @escaping (String) -> Void) {
        // 이미 실행 중이라면 종료 후 재시작
        if audioEngine.isRunning {
            stopRecognition()
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            print("❌ Recognition request 생성 실패")
            return
        }

        // ✅ 오디오 세션 설정
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ 오디오 세션 설정 실패: \(error)")
            return
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        // ✅ 유효한 포맷인지 확인
        guard format.sampleRate > 0, format.channelCount > 0 else {
            print("❌ 유효하지 않은 오디오 포맷: SampleRate=\(format.sampleRate), Channels=\(format.channelCount)")
            return
        }

        // ✅ 기존 tap 제거
        inputNode.removeTap(onBus: 0)

        // ✅ recognition task 시작
        recognitionTask = recognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                updateHandler(result.bestTranscription.formattedString)
            } else if let error = error {
                print("❌ STT 오류: \(error.localizedDescription)")
            }
        }

        // ✅ 입력 버퍼를 request에 연결
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.request?.append(buffer)
        }

        // ✅ 오디오 엔진 시작
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("❌ audioEngine 시작 실패: \(error)")
        }
    }

    func stopRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        request?.endAudio()
        request = nil
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("❌ 오디오 세션 비활성화 실패: \(error)")
        }
    }
}
