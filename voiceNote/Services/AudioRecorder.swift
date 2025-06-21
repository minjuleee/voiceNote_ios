import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    private var completionHandler: ((URL?) -> Void)?
    
    func startRecording(volumeHandler: @escaping (Float) -> Void) {
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            // 🔸 오디오 세션 설정
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder?.delegate = self  // ✅ 델리게이트 설정
            recorder?.isMeteringEnabled = true
            recorder?.record()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.recorder?.updateMeters()
                let power = self.recorder?.averagePower(forChannel: 0) ?? -160
                let normalized = max(0, (power + 60) / 60)
                volumeHandler(normalized)
            }
        } catch {
            print("❌ 녹음 실패: \(error.localizedDescription)")
        }
    }
    
    func stopRecording(completion: @escaping (URL?) -> Void) {
        print("🛑 AudioRecorder.stopRecording 호출됨")
        timer?.invalidate()
        completionHandler = completion
        recorder?.stop()
    }
    
    // ✅ 녹음이 정상적으로 끝난 뒤에 호출되는 델리게이트
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("✅ audioRecorderDidFinishRecording 호출됨: success=\(flag)")
        if flag {
            completionHandler?(recorder.url)
        } else {
            completionHandler?(nil)
        }
        completionHandler = nil
    }
    
    private func getFileURL() -> URL {
        let filename = UUID().uuidString + ".m4a"
        return FileManager.default.temporaryDirectory.appendingPathComponent(filename)
    }
}
