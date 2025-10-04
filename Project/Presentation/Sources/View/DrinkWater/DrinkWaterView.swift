//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import DesignSystem
import DomainLayerInterface
import SwiftUI

public struct DrinkWaterView: View {
    private var viewModel: DrinkWaterViewModel
    
    public init(viewModel: DrinkWaterViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                GeometryReader { proxy in
                    WaterDropView(
                        appearance: viewModel.mainAppearance,
                        progress: viewModel.progress,
                        offset: viewModel.offset
                    )
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        alignment: .center
                    )
                }
                .frame(height: 450)
                
                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(viewModel.drinkWaterCount)잔")
                            .font(.title)
                        Text("\(viewModel.mililiters)")
                            .font(.callout)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("목표: \(Int(viewModel.dailyLimit.rounded()))ml")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if viewModel.isLimitReached {
                            Text("완료!")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
                
                HStack {
                    Button {
                        viewModel.drinkWater()
                    } label: {
                        Text(viewModel.isLimitReached ? "목표 달성!" : "마시기")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(viewModel.isLimitReached ? Color.gray : Color.accent)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLimitReached)
                    
                    
                    Button {
                        viewModel.reset()
                    } label: {
                        Text("초기화")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            // Refresh data when view appears to catch any Widget changes
            viewModel.refreshFromUserDefaults()

            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                viewModel.startAnimation()
            }
        }
    }
}

fileprivate struct WaterDropView: View {
    let appearance: MainAppearance
    let progress: CGFloat
    let offset: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: appearance.fillSystemImage)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .scaleEffect(x: 1.1, y: 1.1)
                .offset(y: -1)
            
            WaterWaveView(
                progress: progress,
                waveHeight: 0.1,
                offset: offset
            )
            .fill(.teal)
            .waterDropGlareEffect()
            .mask {
                Image(systemName: appearance.fillSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
