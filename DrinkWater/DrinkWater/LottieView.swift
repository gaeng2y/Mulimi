//
//  LottieView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/06.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    var lottieFile: String
    var loopMode: LottieLoopMode = .playOnce
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
}
