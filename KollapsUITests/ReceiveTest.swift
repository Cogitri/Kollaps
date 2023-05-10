//
//  ReceiveTest.swift
//  KollapsUITests
//
//  Created by Rasmus Thomsen on 10.05.23.
//

import XCTest
import WormholeWilliam

final class ReceiveTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testReceive() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let ctx = WormholeWilliamSenderContext()
        var error: NSError?
        WormholeWilliamPrepareSendFile(ctx, "/etc/ntp.conf", &error)
        let code = WormholeWilliamSenderContextGetCode(ctx)
        Task.detached {
            var error: NSError?
            WormholeWilliamSenderContextFinishSend(ctx, &error)
        }

        let appWindow = XCUIApplication()/*@START_MENU_TOKEN@*/.windows["Kollaps.ContentView-1-AppWindow-1"]/*[[".windows[\"Kollaps\"]",".windows[\"Kollaps.ContentView-1-AppWindow-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let receiveCode = appWindow/*@START_MENU_TOKEN@*/.textFields["Receive code (e.g. 7-crossover-clockwork)"]/*[[".tabGroups",".groups.textFields[\"Receive code (e.g. 7-crossover-clockwork)\"]",".textFields[\"Receive code (e.g. 7-crossover-clockwork)\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        receiveCode.click()
        receiveCode.typeText(code)
        appWindow.buttons["Next"].click()
        XCTAssert(appWindow/*@START_MENU_TOKEN@*/.buttons["Accept"]/*[[".tabGroups",".groups.buttons[\"Accept\"]",".buttons[\"Accept\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 15))
        appWindow/*@START_MENU_TOKEN@*/.buttons["Accept"]/*[[".tabGroups",".groups.buttons[\"Accept\"]",".buttons[\"Accept\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.click()
        XCTAssert(appWindow.staticTexts["Successfully received file."].exists)
    }
}
