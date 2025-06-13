//
//  TabBar.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tab
    @Binding var isRecording: Bool

    var body: some View {
        HStack {
            Spacer()
            
            // 홈 버튼
            Button(action: {
                selectedTab = .home
            }) {
                Image(systemName: "house.fill")
                    .font(.system(size: 30))
                    .foregroundColor(selectedTab == .home ? .blue : .black)
            }
            
            Spacer()
            
            // 녹음 버튼
            Button(action: {
                if selectedTab != .record {
                    selectedTab = .record
                } else {
                    isRecording.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.orange)
                        .frame(width: 60, height: 60)
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // 디테일 버튼
            Button(action: {
                selectedTab = .detail
            }) {
                Image(systemName: "doc.fill")
                    .font(.system(size: 30))
                    .foregroundColor(selectedTab == .detail ? .blue : .black)
            }
            
            Spacer()
        }
        .padding(.bottom, 10)
        .background(Color.white)
//        .shadow(radius: 5)
    }
}

