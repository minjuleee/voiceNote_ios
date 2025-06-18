//
//  AudioRecorder.swift
//  voiceNote
//
//  Created by 이민주 on 6/14/25.
//

import AVFoundation

class AudioRecorder {
    
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    
    func startRecording(volumeHandler: @escaping (Float) -> Void) {
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.recorder?.updateMeters()
                let power = self.recorder?.averagePower(forChannel: 0) ?? -160
                let normalized = max(0, (power + 60) / 60)
                volumeHandler(normalized)
            }
        } catch {
            print("녹음 실패: \(error)")
        }
    }
    
    func stopRecording(completion: @escaping (URL?) -> Void) {
        recorder?.stop()
        timer?.invalidate()
        completion(recorder?.url)
    }
    
    private func getFileURL() -> URL {
        let filename = UUID().uuidString + ".m4a"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        return path
    }
}

