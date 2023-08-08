//
//  OnboardingVIew.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/08/03.
//

import SwiftUI

struct OnboardingVIew: View {
    @Binding var isFirstLaunching: Bool
    @State var glassOfWater: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text("하루에 마실 잔 수를 입력해주세요.")
                    .foregroundColor(.black)
                    .font(.title2)
                    .padding(.bottom, 50)
                
                TextField("숫자만 입력하시면 돼요", text: $glassOfWater)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 50)
                
                Button {
                    isFirstLaunching.toggle()
                } label: {
                    Text("시작")
                }
                .buttonStyle(.bordered)
                .background(.teal)
                .foregroundColor(.white)
                .cornerRadius(7)
            }
        }
        .ignoresSafeArea()
    }
}
