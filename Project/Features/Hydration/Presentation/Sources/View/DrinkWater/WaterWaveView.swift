//
//  WaterWaveView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import SwiftUI

struct WaterWaveView: Shape {
    var progress: CGFloat
    // Wave Height
    var waveHeight: CGFloat
    // Initial Animation Start
    var offset: CGFloat

    // Enabling Animation
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            let startY = waveY(
                at: 0,
                progressHeight: progressHeight,
                height: height
            )

            path.move(to: CGPoint(x: 0, y: startY))

            // 성능 최적화: stride를 4로 증가 (픽셀당 계산 횟수 감소)
            for value in stride(from: 0, to: rect.width, by: 4) {
                path.addLine(
                    to: CGPoint(
                        x: value,
                        y: waveY(
                            at: value,
                            progressHeight: progressHeight,
                            height: height
                        )
                    )
                )
            }

            // 마지막 지점을 명시적으로 추가하여 부드럽게 연결
            path.addLine(to: CGPoint(x: rect.width, y: progressHeight))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }

    private func waveY(
        at x: CGFloat,
        progressHeight: CGFloat,
        height: CGFloat
    ) -> CGFloat {
        // 첫 번째 wave: 주요 wave (낮은 frequency, 큰 amplitude)
        let primaryWave = sin(Angle(degrees: x * 0.5 + offset).radians)

        // 두 번째 wave: 보조 wave (높은 frequency, 작은 amplitude)
        let secondaryWave = sin(Angle(degrees: x * 1.5 + offset * 1.3).radians) * 0.3

        // 세 번째 wave: 디테일 wave (매우 높은 frequency, 매우 작은 amplitude)
        let detailWave = sin(Angle(degrees: x * 2.5 - offset * 0.7).radians) * 0.15

        return progressHeight + (height * (primaryWave + secondaryWave + detailWave))
    }
}

#Preview {
    WaterWaveView(
        progress: 0.125,
        waveHeight: 0.1,
        offset: 0
    )
}
