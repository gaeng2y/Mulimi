//
//  MainView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
//        NavigationStack {
//            DrinkView()
//                .toolbar {
//                    Button {
//                        print("setting")
//                    } label: {
//                        Image(systemName: "gear")
//                    }
//                }
//        }
        DrinkView()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.gaeng2y.drinkwater"
        return UserDefaults(suiteName: appGroupId)!
    }
}

