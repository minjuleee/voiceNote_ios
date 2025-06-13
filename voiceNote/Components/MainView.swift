//
//  MainView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    @State private var isRecording: Bool = false  // 녹음 상태

    var body: some View {
        NavigationStack {   // ✅ 이 부분 추가
            VStack {
                // 현재 선택된 탭에 따라 화면 전환
                switch selectedTab {
                case .home:
                    HomeView()
                case .record:
                    RecordView(isRecording: $isRecording)
                case .detail:
                    DetailView()
                }
                
                // 하단 탭바 (이제 TabBar로 이름 변경됨!)
                TabBar(selectedTab: $selectedTab, isRecording: $isRecording)
            }
        }
    }
}
