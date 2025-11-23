//
//  RootView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

public struct RootView<Content: View>: View {
    @StateObject private var viewModel: AuthenticationViewModel
    private let content: () -> Content

    public init(
        viewModel: @autoclosure @escaping () -> AuthenticationViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self.content = content
    }

    public var body: some View {
        Group {
            if viewModel.isAuthenticated {
                content()
            } else {
                SignInView(viewModel: viewModel)
            }
        }
    }
}
