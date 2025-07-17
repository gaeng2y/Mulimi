//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import SwiftUI

//public struct DrinkWaterView: View {
//    public var body: some View {
//        ZStack {
//            Color(.systemBackground)
//                .ignoresSafeArea(edges: [.top, .horizontal])
//            
//            VStack {
//                GeometryReader { proxy in
//                    let size = proxy.size
//                    
//                    ZStack {
//                        Image(systemName: "drop.fill")
//                            .resizable()
//                            .renderingMode(.template)
//                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.white)
//                            .scaleEffect(x: 1.1, y: 1.1)
//                            .offset(y: -1)
//                        
//                        WaterWaveView(
//                            progress: store.progress,
//                            waveHeight: 0.1,
//                            offset: store.offset
//                        )
//                        .fill(.teal)
//                        .overlay {
//                            ZStack {
//                                // water drop
//                                GlareCircleView(sizeConstant: 15,
//                                              offset: .init(x: -20, y: 0))
//                                
//                                GlareCircleView(sizeConstant: 15,
//                                              offset: .init(x: 40, y: 30))
//                                
//                                GlareCircleView(sizeConstant: 25,
//                                              offset: .init(x: -30, y: 80))
//                                
//                                GlareCircleView(sizeConstant: 25,
//                                              offset: .init(x: 50, y: 70))
//                                
//                                GlareCircleView(sizeConstant: 10,
//                                              offset: .init(x: 40, y: 100))
//                            }
//                        }
//                        .mask {
//                            Image(systemName: "drop.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                        }
//                    }
//                    .frame(width: size.width, height: size.height, alignment: .center)
//                }
//                .frame(height: 450)
//                
//                HStack(alignment: .firstTextBaseline) {
//                    Text(store.glassString)
//                        .font(.title)
//                    Text(store.liter)
//                        .font(.callout)
//                }
//                .padding()
//                
//                HStack {
//                    Button {
//                        store.send(.drinkButtonTapped)
//                    } label: {
//                        Text("마시기")
//                            .font(.headline)
//                            .fontWeight(.bold)
//                            .padding()
//                            .background(store.drinkButtonBackgroundColor)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .disabled(store.isDisableDrinkButton)
//                    
//                    
//                    Button {
//                        store.send(.resetButtonTapped)
//                    } label: {
//                        Text("초기화")
//                            .font(.headline)
//                            .fontWeight(.bold)
//                            .padding()
//                            .background(.white)
//                            .foregroundColor(.black)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            store.send(.subscribeWater)
//            
//            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) { () -> Void in
//                store.send(.startAnimation)
//            }
//        }
//    }
//}
//
//
//#Preview {
//    DrinkWaterView(store: Store(initialState: DrinkWater.State()) {
//        DrinkWater()
//    })
//}
