//
//  SplashView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/06.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LottieView()
                .ignoresSafeArea()
            
            FadeInOutView(text: "물리미", startTime: 1)
                .padding()
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
