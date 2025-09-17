//
//  DIEnvironment.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import Foundation

public enum DIEnvironment {
    case production
    case preview
    case testing

    public static var current: DIEnvironment {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return .preview
        }
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return .testing
        }
        #endif
        return .production
    }
}