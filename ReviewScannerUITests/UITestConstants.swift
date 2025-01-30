struct UITestConstants {
    // modify the credentials so that the features available only for logged users can be tested
    // all three variables have to be associated with the same user
    static let validNickname = "example_user"
    static let validLoginEmail = "user@example.com"
    static let validLoginPassword = "example_password"
    
    // modify the valid barcode so that it matches a product in the database
    static let validBarcode = "1234567890123"
    static let invalidBarcode = "0909090909090"
}
