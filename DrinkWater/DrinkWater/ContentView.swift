//
//  ContentView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var counter = UserDefaults.shared.integer(forKey: "drinkwater")
    
    var body: some View {
        VStack {
            Image("waterbottle")
                .resizable()
                .frame(
                    width: 200,
                    height: 200,
                    alignment: .center
                )
            Text("\(counter)잔")
                .font(.largeTitle)
            Button(action: {
                guard self.counter < 8 else { return }
                self.counter += 1
                UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
                    UserDefaults.shared.set(value, forKey: key)
                }
                UserDefaults.shared.set(self.counter, forKey: "drinkwater")
                WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
            }) {
                Text("마시기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.gaeng2y.drinkwater"
        return UserDefaults(suiteName: appGroupId)!
    }
}

