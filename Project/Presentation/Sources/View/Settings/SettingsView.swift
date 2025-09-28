//
//  SettingsView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 9/28/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import SwiftUI

public struct SettingsView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List(SettingMenu.allCases) { menu in
                Label(menu.title, systemImage: menu.systemImage)
            }
            .navigationTitle("설정")
        }
        
    }
}
