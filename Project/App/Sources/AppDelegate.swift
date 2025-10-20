//
//  AppDelegate.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/12/24.
//

import UIKit
import FirebaseCore
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()

        return true
    }
}
