struct UITestConstants {
    // modify the credentials so that the features available only for logged users can be tested
    // all three variables have to be associated with the same user
    static let validNickname = "User1"
    static let validLoginEmail = "user1@mail.com"
    static let validLoginPassword = "user1"
    
    // modify the valid barcode so that it matches a product in the database
    static let validBarcode = "3564121626451"
    static let invalidBarcode = "9999999999999"
}
