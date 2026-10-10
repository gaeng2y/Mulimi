//
//  GlareCircleView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

internal import DesignSystemFoundation
import SwiftUI

struct GlareCircleView: View {
    let opacity: CGFloat = 0.1
    let sizeConstant: CGFloat
    let offset: CGPoint

    var body: some View {
        CircleHighlight(diameter: sizeConstant, color: DesignTokens.Palette.highlight.opacity(opacity))
            .offset(x: offset.x, y: offset.y)
    }
}

#Preview {
    GlareCircleView(sizeConstant: 15, offset: .init(x: -20, y: 0))
}
