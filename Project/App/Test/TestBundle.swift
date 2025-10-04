//
//  TestBundle.swift
//  Test
//
//  Created by Kyeongmo Yang on 9/28/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct TestBundle: WidgetBundle {
    var body: some Widget {
        Test()
        TestControl()
        TestLiveActivity()
    }
}
