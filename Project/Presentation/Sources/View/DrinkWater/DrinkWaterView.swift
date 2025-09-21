//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import DesignSystem
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
                    ZStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .scaleEffect(x: 1.1, y: 1.1)
                            .offset(y: -1)
                        
                        WaterWaveView(
                            progress: viewModel.progress,
                            waveHeight: 0.1,
                            offset: viewModel.offset
                        )
                        .fill(.teal)
                        .waterDropGlareEffect()
                        .mask {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height,
                            alignment: .center
                        )
                    }
                }
                .frame(height: 450)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(viewModel.drinkWaterCount)잔")
                        .font(.title)
                    Text("\(viewModel.mililiters)")
                        .font(.callout)
                }
                .padding()
                
                HStack {
                    Button {
                        viewModel.drinkWater()
                    } label: {
                        Text("마시기")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.accent)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(false)
                    
                    
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
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                viewModel.startAnimation()
            }
        }
    }
    
    private struct WaterDrop: View {
        var body: some View {
            Image(systemName: "drop.fill")
        }
    }
}
