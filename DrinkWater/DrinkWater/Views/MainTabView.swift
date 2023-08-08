//
//  MainTabView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/28.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        MainView()
            .fullScreenCover(isPresented: $isFirstLaunching) {
                OnboardingVIew(isFirstLaunching: $isFirstLaunching)
            }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
