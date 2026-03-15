//
//  MockNavigationRouter.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import PresentationLayer

public final class MockNavigationRouter: NavigationRouter {
    override public init() {
        super.init()
    }

    // Mock implementation with debug logging for previews
    override public func navigate(to route: SettingsRoute) {
        print("Mock Navigation to: \(route)")
        super.navigate(to: route)
    }

    override public func navigateBack() {
        print("Mock Navigation Back")
        super.navigateBack()
    }

    override public func resetSettingsPath() {
        print("Mock Reset Settings Path")
        super.resetSettingsPath()
    }

    // Convenience method for preview setup
    public func setupPreviewData() {
        // Add some sample navigation state for previews if needed
    }
}
