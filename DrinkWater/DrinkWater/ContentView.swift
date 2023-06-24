//
//  ContentView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var counter = 0
    
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
                self.counter += 1
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
