//
//  RecordView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss  // 뒤로가기 위해 사용

    @State private var isRecording: Bool = false
    @State private var recognizedText: String = "실시간 음성 텍스트화"
    @State private var selectedTab: Tab = .record  // 탭바 상태 관리

    var body: some View {
        VStack {
            // 상단 바
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                Text(isRecording ? "녹음 중..." : "녹음 대기 중")
                    .font(.headline)
                    .foregroundColor(.blue)

                Spacer()

                Spacer().frame(width: 30)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()

            // STT 결과 표시 박스
            VStack {
                Spacer()
                
                Image(systemName: "waveform")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text(recognizedText)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 400)
            .background(isRecording ? Color.red : Color.blue)
            .cornerRadius(30)
            .padding(.horizontal, 20)

            Spacer()

            // 탭바 삽입
            TabBar(selectedTab: $selectedTab, isRecording: $isRecording)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RecordView()
}
