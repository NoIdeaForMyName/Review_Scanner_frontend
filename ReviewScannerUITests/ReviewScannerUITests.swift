//
//  ReviewScannerUITests.swift
//  ReviewScannerUITests
//
//  Created by Michał Maksanty on 21/11/2024.
//

import XCTest

final class ReviewScannerUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // helper function used at the start of every test that requires login
    func login(email: String, password: String) throws {
        let loginScreenButton = app.buttons["Log In"]
        loginScreenButton.tap()
        
        let emailTextField = app.textFields["Enter your e-mail address"]
        emailTextField.tap()
        emailTextField.typeText(email)
        
        let passwordTextField = app.secureTextFields["Enter your password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        loginButton.waitForNonExistence(timeout: 1)
    }
    
    // helper function that performs manual scanning of a product with a specified barcode
    func scanBarcode(barcode: String) throws {
        if barcode.count != 13 {
            XCTFail("Barcode \(barcode) doesn't have exactly 13 digits")
        }
        
        let scannerButton = app.buttons["Scan"]
        scannerButton.tap()
        
        let digitTextFields = app.textFields.allElementsBoundByIndex
        
        for (digit, digitTextField) in zip(barcode, digitTextFields) {
            digitTextField.tap()
            digitTextField.typeText(String(digit))
        }
    }
    
    func testHomeScreenForGuestUsers() throws {
        let demoVideoButton = app.buttons["questionmark.circle"]
        XCTAssertTrue(demoVideoButton.exists)
        
        let titleText = app.staticTexts["Review Scanner"]
        XCTAssert(titleText.exists)
        
        let helloText = app.staticTexts["Hello"]
        XCTAssert(helloText.exists)
        
        let scannerButton = app.buttons["Scan"]
        XCTAssert(scannerButton.exists)
        
        let historyButton = app.buttons["History"]
        XCTAssert(historyButton.exists)
        
        let loginScreenButton = app.buttons["Log In"]
        XCTAssert(loginScreenButton.exists)
    }
    
    func testHomeScreenForLoggedUsers() throws {
        try login(email: UITestConstants.validLoginEmail, password: UITestConstants.validLoginPassword)
        
        let demoVideoButton = app.buttons["questionmark.circle"]
        XCTAssertTrue(demoVideoButton.exists)
        
        let logoutButton = app.buttons["arrow.left.circle"]
        XCTAssertTrue(logoutButton.exists)
        
        let titleText = app.staticTexts["Review Scanner"]
        XCTAssert(titleText.exists)
        
        let helloText = app.staticTexts["Hello \(UITestConstants.validNickname)"]
        XCTAssert(helloText.exists)
        
        let scannerButton = app.buttons["Scan"]
        XCTAssert(scannerButton.exists)
        
        let historyButton = app.buttons["History"]
        XCTAssert(historyButton.exists)
        
        let myReviewsButton = app.buttons["My reviews"]
        XCTAssert(myReviewsButton.exists)
    }
    
    func testLoginScreen() throws {
        let loginScreenButton = app.buttons["Log In"]
        loginScreenButton.tap()
        
        let titleText = app.staticTexts["Login to existing account"]
        XCTAssert(titleText.exists)
        
        let emailTextField = app.textFields["Enter your e-mail address"]
        XCTAssert(emailTextField.exists)
        
        let passwordTextField = app.secureTextFields["Enter your password"]
        XCTAssert(passwordTextField.exists)
        
        let noAccountButton = app.buttons["Do not have an account? Create new."]
        XCTAssert(noAccountButton.exists)
        
        let loginButton = app.buttons["Login"]
        XCTAssert(loginButton.exists)
    }
    
    func testRegistrationScreen() {
        let loginScreenButton = app.buttons["Log In"]
        loginScreenButton.tap()
        
        let noAccountButton = app.buttons["Do not have an account? Create new."]
        noAccountButton.tap()
        
        let titleText = app.staticTexts["Create new account"]
        XCTAssert(titleText.exists)
        
        let nicknameTextField = app.textFields["Enter your nickname"]
        XCTAssert(nicknameTextField.exists)
        
        let emailTextField = app.textFields["Enter your e-mail address"]
        XCTAssert(emailTextField.exists)
        
        let passwordTextField = app.secureTextFields["Enter your password"]
        XCTAssert(passwordTextField.exists)
        
        let repeatPasswordTextField = app.secureTextFields["Repeat your password"]
        XCTAssert(repeatPasswordTextField.exists)
        
        let registerButton = app.buttons["Register"]
        XCTAssert(registerButton.exists)
    }
    
    func testSuccessfulLoggingIn() throws {
        try login(email: UITestConstants.validLoginEmail, password: UITestConstants.validLoginPassword)
        
        let loginButton = app.buttons["Login"]
        XCTAssertFalse(loginButton.waitForExistence(timeout: 1))
    }
    
    func testUnsuccessfulLoggingIn() throws {
        try login(email: UITestConstants.validLoginEmail, password: "wrong password")
        
        let loginButton = app.buttons["Login"]
        XCTAssertFalse(loginButton.waitForNonExistence(timeout: 1))
        
        let errorMessage = app.staticTexts["Unauthorized: Invalid credentials"]
        XCTAssert(errorMessage.waitForExistence(timeout: 1))
    }
    
    func testLogout() throws {
        try login(email: UITestConstants.validLoginEmail, password: UITestConstants.validLoginPassword)
        
        let logoutButton = app.buttons["arrow.left.circle"]
        logoutButton.tap()
        
        let helloText = app.staticTexts["Hello"]
        XCTAssert(helloText.waitForExistence(timeout: 1))
        
        let loginScreenButton = app.buttons["Log In"]
        XCTAssert(loginScreenButton.waitForExistence(timeout: 1))
    }
    
    func testBarcodeScannerManualTypingWithValidBarcode() throws {
        try scanBarcode(barcode: UITestConstants.validBarcode)
        
        // check for a star icon which means that navigation to product view was successful
        let starIcon = app.images["star"]
        XCTAssert(starIcon.waitForExistence(timeout: 5))
    }
    
    func testBarcodeScannerManualTypingWithInvalidBarcode() throws {
        try scanBarcode(barcode: UITestConstants.invalidBarcode)
        
        let notFoundText = app.staticTexts["This product is currently not in our database."]
        XCTAssert(notFoundText.waitForExistence(timeout: 5))
    }
    
    func testRecentlyScannedProductsAfterScanningProduct() throws {
        try scanBarcode(barcode: UITestConstants.validBarcode)
        
        // check for a star icon which means that navigation to product view was successful
        let starIcon = app.images["star"]
        XCTAssert(starIcon.waitForExistence(timeout: 5))
        
        // the 2nd (index 1) Text() stores the product name
        let productName = app.staticTexts.element(boundBy: 1).label
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        let historyButton = app.buttons["History"]
        historyButton.tap()
        
        sleep(5)
        
        let titleText = app.staticTexts["Recently viewed products"]
        XCTAssert(titleText.waitForExistence(timeout: 5))
        
        // the 2nd (index 1) Text() stores the product title (avg. grade + name)
        let mostRecentlyViewedProductTitle = app.staticTexts.element(boundBy: 1)
        XCTAssert(mostRecentlyViewedProductTitle.exists)
        
        // remove the average grade and leave only the product name
        let mostRecentlyViewedProductName = String(mostRecentlyViewedProductTitle.label.dropFirst(5))
    
        // check if the scanned product was later shown as the most recently viewed product
        XCTAssertEqual(productName, mostRecentlyViewedProductName)
    }
}
