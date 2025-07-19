//
//  WaterDropGlareEffectModifier.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 7/19/24.
//

import SwiftUI

public struct WaterDropGlareEffectModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    // water drop
                    GlareCircleView(sizeConstant: 15,
                                  offset: .init(x: -20, y: 0))
                    
                    GlareCircleView(sizeConstant: 15,
                                  offset: .init(x: 40, y: 30))
                    
                    GlareCircleView(sizeConstant: 25,
                                  offset: .init(x: -30, y: 80))
                    
                    GlareCircleView(sizeConstant: 25,
                                  offset: .init(x: 50, y: 70))
                    
                    GlareCircleView(sizeConstant: 10,
                                  offset: .init(x: 40, y: 100))
                }
            }
    }
    
    public init() {}
}

public extension View {
    func waterDropGlareEffect() -> some View {
        modifier(WaterDropGlareEffectModifier())
    }
}
