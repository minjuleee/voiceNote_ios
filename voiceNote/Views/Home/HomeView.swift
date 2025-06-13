//
//  HomeView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .home
    @State private var isRecording: Bool = false
    
    @State private var memos: [Memo] = [
        Memo(title: "녹음메모 제목", summary: "AI 요약 - 어쩌구 저쩌구", date: "2025.05.17 토 오후 06:52 18초"),
        Memo(title: "안드로이드 프로그래밍 강의", summary: "AI 요약 - 어쩌구 저쩌구", date: "2025.05.17 토 오후 06:52 18초")
    ]
    
    var filteredMemos: [Memo] {
        if searchText.isEmpty {
            return memos
        } else {
            return memos.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            // 검색바
            HStack {
                TextField("검색어를 입력하세요", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .padding(.leading, 5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 10)
            
            // 리스트 (삭제 가능)
            List {
                ForEach(filteredMemos, id: \.self) { memo in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(memo.title)
                            .font(.headline)
                        Text(memo.summary)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(memo.date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deleteMemo)
            }
            .listStyle(.plain)
            
            Spacer()
            
            TabBar(selectedTab: $selectedTab, isRecording: $isRecording)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedTab) { tab in
                    switch tab {
                    case .home:
                        // 그대로 유지
                        break
                    case .record:
                        // 녹음 페이지로 이동
                        // NavigationLink 또는 NavigationStack으로 이동 처리
                        break
                    case .detail:
                        // 상세 페이지 이동
                        break
                    }
                }
    }
    
    private func deleteMemo(at offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
    }
}

struct Memo: Hashable {
    let title: String
    let summary: String
    let date: String
}



#Preview {
    HomeView()
}
