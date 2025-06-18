//
//  RecordView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct RecordView: View {
    
    @StateObject private var viewModel = RecordViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            
            // 제목
            Text(viewModel.isRecording ? "녹음 중..." : "스마트 음성 메모장")
                .font(.title)
                .fontWeight(.bold)
            
            // 웨이브폼 (볼륨 레벨 시각화)
            WaveformView(level: viewModel.volumeLevel)
                .frame(height: 100)
                .padding()
            
            // 실시간 텍스트 표시
            ScrollView {
                Text(viewModel.liveText)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 200)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 녹음 버튼
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(viewModel.isRecording ? .red : .blue)
            }
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    RecordView()
}
