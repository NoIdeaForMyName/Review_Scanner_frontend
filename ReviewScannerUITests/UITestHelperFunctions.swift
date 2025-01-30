import XCTest

// helper function used at the start of every test that requires login
func login(app: XCUIApplication, email: String, password: String) throws {
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
func scanBarcode(app: XCUIApplication, barcode: String) throws {
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
