import XCTest

final class ReviewScannerUIPerformanceTests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
    
    func testUserLoginPerformance() throws {
        app.launch()
        
        let loginScreenButton = app.buttons["Log In"]
        loginScreenButton.tap()
        
        let emailTextField = app.textFields["Enter your e-mail address"]
        emailTextField.tap()
        emailTextField.typeText(UITestConstants.validLoginEmail)
        
        let passwordTextField = app.secureTextFields["Enter your password"]
        passwordTextField.tap()
        passwordTextField.typeText(UITestConstants.validLoginPassword)
        
        let loginButton = app.buttons["Login"]
        
        let start = Date()
        
        loginButton.tap()
        print("siemka")
        
        let logoutButton = app.buttons["arrow.left.circle"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))

        let elapsedTime = Date().timeIntervalSince(start)
        
        print("Time taken for login: \(elapsedTime) seconds")
    }
    
    func testUserLogoutPerformance() throws {
        app.launch()
        
        try login(app: app, email: UITestConstants.validLoginEmail, password: UITestConstants.validLoginPassword)
        
        let logoutButton = app.buttons["arrow.left.circle"]
        
        let start = Date()
        
        logoutButton.tap()
        
        let helloText = app.staticTexts["Hello"]
        XCTAssert(helloText.waitForExistence(timeout: 5))
        
        let elapsedTime = Date().timeIntervalSince(start)
        
        print("Time taken for logout: \(elapsedTime) seconds")
    }
    
    func testManualScanningPerformance() throws {
        app.launch()
        
        let scannerButton = app.buttons["Scan"]
        scannerButton.tap()
        
        let digitTextFields = app.textFields.allElementsBoundByIndex
        
        var start: Date? = nil
        for (digit, digitTextField) in zip(UITestConstants.validBarcode, digitTextFields) {
            digitTextField.tap()
            
            if digitTextField == digitTextFields.last {
                start = Date()
            }
            
            digitTextField.typeText(String(digit))
        }
        
        let starIcon = app.images["star"]
        XCTAssert(starIcon.waitForExistence(timeout: 5))
        
        let elapsedTime = Date().timeIntervalSince(start!)
        
        print("Time taken for processing scanning: \(elapsedTime) seconds")
    }
    
    func testRecentlyViewedProductsLoadingPerformance() throws {
        app.launch()
        
        let historyButton = app.buttons["History"]
        
        let start = Date()
        
        historyButton.tap()
        
        let titleText = app.staticTexts["Recently viewed products"]
        XCTAssert(titleText.waitForExistence(timeout: 5))
        
        let elapsedTime = Date().timeIntervalSince(start)
        
        print("Time taken for loading recently viewed products: \(elapsedTime) seconds")
    }
    
    func testMyReviewsLoadingPerformance() throws {
        app.launch()

        try login(app: app, email: UITestConstants.validLoginEmail, password: UITestConstants.validLoginPassword)
        
        let myReviewsButton = app.buttons["My reviews"]
        
        let start = Date()
        
        myReviewsButton.tap()
        
        let titleText = app.staticTexts["My reviews"]
        XCTAssert(titleText.waitForExistence(timeout: 5))
        
        let elapsedTime = Date().timeIntervalSince(start)
        
        print("Time taken for loading user's reviews: \(elapsedTime) seconds")
    }
    
}
