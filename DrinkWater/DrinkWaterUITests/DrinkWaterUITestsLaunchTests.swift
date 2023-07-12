//
//  DrinkWaterUITestsLaunchTests.swift
//  DrinkWaterUITests
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import XCTest

final class DrinkWaterUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override class func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("0Launch")
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        snapshot("01LoginScreen")
    }
}
