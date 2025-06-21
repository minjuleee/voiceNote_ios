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
            let step = width / CGFloat(max(volumes.count, 1)) // 0 나누기 방지

            Path { path in
                for (i, vol) in volumes.enumerated() {
                    let x = CGFloat(i) * step
                    let y = height / 2 - CGFloat(vol) * height / 2
                    path.move(to: CGPoint(x: x, y: height / 2))
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

