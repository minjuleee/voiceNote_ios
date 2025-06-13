//
//  DetailView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) var dismiss  // 뒤로가기
    @State private var selectedTab: Tab = .detail  // 탭 상태 관리
    
    // 샘플 데이터
    let memoTitle: String = "녹음메모 제목"
    let date: String = "2025.05.17 토 06:52"
    let rawText: String = "실시간 음성 텍스트화"
    let summaryText: String = "요약한 메모"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
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
                
                Text(memoTitle)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer().frame(width: 30)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // 날짜
            Text(date)
                .font(.subheadline)
                .padding(.horizontal, 20)
            
            // 오디오 플레이어 (지금은 더미)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 60)
                .overlay(
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.title)
                        Spacer()
                        Text("1:21")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 20)
                )
                .padding(.horizontal, 20)
            
            // 실시간 원본 텍스트
            VStack(alignment: .leading) {
                Text(rawText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            // 요약 텍스트
            VStack(alignment: .leading) {
                Text(summaryText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // 하단 탭바 삽입
            TabBar(selectedTab: $selectedTab, isRecording: .constant(false))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DetailView()
}
