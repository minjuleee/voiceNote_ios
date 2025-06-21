//
//  WaveformView.swift
//  voiceNote
//
//  Created by 이민주 on 6/14/25.
//

import SwiftUI

struct WaveformView: View {
    var volumes: [Float]

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            let step = width / CGFloat(max(volumes.count, 1)) * 1.5

            Path { path in
                for (i, vol) in volumes.enumerated() where i % 2 == 0 {
                    let x = CGFloat(i) * step
                    let normalized = max(0, min(1, (vol + 60) / 60))
                    let barHeight = CGFloat(normalized) * height

                    path.move(to: CGPoint(x: x, y: height / 2 + barHeight / 2))
                    path.addLine(to: CGPoint(x: x, y: height / 2 - barHeight / 2))
                }
            }
            .stroke(Color.white, lineWidth: 1)
        }
    }
}



