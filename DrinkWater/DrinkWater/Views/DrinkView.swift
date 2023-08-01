//
//  DrinkView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/28.
//

import SwiftUI
import WidgetKit

struct DrinkView: View {
    @State private var counter = UserDefaults.shared.integer(forKey: String.glassesOfToday) {
        willSet {
            UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
                UserDefaults.shared.set(value, forKey: key)
            }
        }
        didSet {
            self.progress = CGFloat(self.counter) / 8
            self.milliliter = self.counter * 250
        }
    }
    @State private var isPresented: Bool = false
    @State var progress: CGFloat = CGFloat(UserDefaults.shared.integer(forKey: String.glassesOfToday)) / 8
    @State var startAnimation: CGFloat = 0
    
    @State var milliliter = UserDefaults.shared.integer(forKey: String.glassesOfToday) * 250
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                // MARK: 물방울
            ZStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .scaleEffect(x: 1.1, y: 1.1)
                            .offset(y: -1)
                        
                        WaterWave(progress: self.progress, waveHeight: 0.1, offset: self.startAnimation)
                            .fill(.teal)
                            // water drop
                            .overlay {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 15, height: 15)
                                        .offset(x: -20)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 15, height: 15)
                                        .offset(x: 40, y: 30)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 25, height: 25)
                                        .offset(x: -30, y: 80)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 25, height: 25)
                                        .offset(x: 50, y: 70)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 10, height: 10)
                                        .offset(x: 40, y: 100)
                                }
                            }
                            .mask {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                    }
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .onAppear {
                        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                            startAnimation = 360
                        }
                    }
                }
                .frame(height: 450)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
                HStack {
                    Text("\(counter)잔")
                        .font(.title)
                    
                    Text("(\(self.getLiter()))")
                        .font(.body)
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
                
                HStack(spacing: 20) {
                    // MARK: 물마시기 버튼
                    Button(action: {
                        guard self.counter < 8 else {
                            isPresented = true
                            return
                        }
                        
                        self.counter += 1
                        
                        UserDefaults.shared.set(self.counter, forKey: String.glassesOfToday)
                        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
                    }) {
                        Text("마시기")
                            .padding()
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $isPresented, content: {
                        Alert(title: Text(""), message: Text("지금은 8잔까지만 설정 가능합니다 ㅜㅜ"))}
                    )
                    
                    // MARK: 초기화 버튼
                    Button(action: {
                        self.counter = 0
                        UserDefaults.shared.set(0, forKey: String.glassesOfToday)
                        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
                    }) {
                        Text("초기화")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private func getLiter() -> String {
        guard self.milliliter >= 1000 else { return "\(self.milliliter)ML"}
        return "\(Float(self.milliliter) / 1000)L"
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(progress: 0, startAnimation: 0)
    }
}
