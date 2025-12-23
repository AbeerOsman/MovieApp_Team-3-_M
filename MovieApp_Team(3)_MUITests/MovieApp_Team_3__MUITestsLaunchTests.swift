//
//  MovieApp_Team_3__MUITestsLaunchTests.swift
//  MovieApp_Team(3)_MUITests
//
//  Created by Abeer Jeilani Osman  on 03/07/1447 AH.
//

import XCTest

final class MovieApp_Team_3__MUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
