//
//  WaveformView.swift
//  voiceNote
//
//  Created by 이민주 on 6/14/25.
//

import SwiftUI

struct WaveformView: View {
    
    var level: Float  // 0.0 ~ 1.0
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
            
            Capsule()
                .fill(Color.blue)
                .frame(width: CGFloat(level) * 300, height: 10)
                .animation(.linear, value: level)
        }
    }
}

