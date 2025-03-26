//
//  SwiftUI_DaysUITests.swift
//  SwiftUI-DaysUITests
//
//  Created by Oleg991 on 04.04.2024.
//

import XCTest

@MainActor
final class SwiftUI_DaysUITests: XCTestCase {
    private let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app.launchArguments.removeAll()
        app = nil
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        app.launch()
    }
}
