//
//  ReviewScannerTests.swift
//  ReviewScannerTests
//
//  Created by Michał Maksanty on 21/11/2024.
//

import Testing
import Foundation
@testable import ReviewScanner


@Suite(.serialized) struct API_Tests {
    
    var environmentData: EnvironmentData = .init()
    
    private func setUp() {
        // set up code
    }

    @Test("Check fetching product data", arguments: [
        ("5909990642571",
         ProductData(id: 5, name: "orofar", description: "taki tam lek\n\n\n", image: "http://127.0.0.1:8080/uploads/prod_5.jpg", barcode: "5909990642571", average_grade: 2.5, grade_count: 2, reviews: [
            ReviewData(id: 5, title: "hahaha", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 5, product_name: "orofar", grade: 2, description: "jakshajbs", price: 6.66, shop: ShopData(id: 3, name: "Prima"), media: []),
            ReviewData(id: 4, title: "witam", user: UserData(id: 5, email: "m.m@m.m", nickname: "michal"), product_id: 5, product_name: "orofar", grade: 3.0, description: "nie wiem co mam rzec", price: 22.22, shop: ShopData(id: 3, name: "Prima"), media: [ReviewMediaData(id: 4, url: "http://127.0.0.1:8080/uploads/rev_4_4.jpg")])
        ]),
         nil as APIError?),
        
        ("123",
         nil as ProductData?,
         Optional<APIError>(APIError.notFound("Product not found"))),
        
        ("5900259133311",
         ProductData(id: 6, name: "czipery", description: "czipsiki", image: "http://127.0.0.1:8080/uploads/prod_6.jpg", barcode: "5900259133311", average_grade: 2.0, grade_count: 1, reviews: [
            ReviewData(id: 8, title: "Onions flavour is better", user: ReviewScanner.UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 6, product_name: "czipery", grade: 2.0, description: "Fences", price: 28585.0, shop: ShopData(id: 6, name: "Rjdnfn"), media: [ReviewMediaData(id: 7, url: "http://127.0.0.1:8080/uploads/rev_8_7.jpg")])
         ]),
         nil as APIError?),
        
        ("5906734832427",
         ProductData(id: 8, name: "Natalie", description: "Bakalie smaczne", image: "http://127.0.0.1:8080/uploads/prod_8.jpg", barcode: "5906734832427", average_grade: 3.0, grade_count: 2, reviews: [
            ReviewData(id: 10, title: "Heheh", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 8, product_name: "Natalie", grade: 3.0, description: "Hahaha", price: 5.55, shop: ShopData(id: 5, name: "Polo"), media: []), ReviewData(id: 9, title: "Hsjabdb", user: UserData(id: 8, email: "test@t.t", nickname: "Test"), product_id: 8, product_name: "Natalie", grade: 3.0, description: "Heaven", price: 6.55, shop: ShopData(id: 5, name: "Polo"), media: [ReviewMediaData(id: 8, url: "http://127.0.0.1:8080/uploads/rev_9_8.jpg")])
         ]),
         nil as APIError?),
        
        ("abc",
         nil as ProductData?,
         Optional<APIError>(APIError.notFound("Product not found")))
    ])
    func fetchingProductData(testData: (String, ProductData?, APIError?)) async throws {
        setUp()
        let modelView: BarcodeScannerModelView = BarcodeScannerModelView()
        
        let barcode = testData.0
        let testProductData = testData.1
        let testError = testData.2
        
        modelView.fetchProductData(environmentData: environmentData, barcode: barcode)
        while modelView.isLoading {} // wait for the data to be fetched
        if let testProductDataUnpacked = testProductData {
            try #require(modelView.success)
            #expect(modelView.productData! == testProductDataUnpacked)
        } else if let testErrorUnpacked = testError{
            try #require(modelView.error)
            print(modelView.errorData!)
            #expect(testErrorUnpacked.errorDescription == modelView.errorData!.errorDescription)
        }
    }
    
    @Test("Check login action", arguments: [
        (true, "a@a.a", "aaa", "Aaa"), // good
        (true, "user@example.com", "example_password", "example_user"), // good
        (false, "user@example.com", "wrong_password", "nickname"), // wrong
        (false, "wrong_email", "password", "nickname") // wrong
    ])
    func loggingIn(testData: (Bool, String, String, String)) async throws {
        setUp()
        let modelView: LoginViewModel = LoginViewModel()
        
        let goodCredentials = testData.0
        let testEmail = testData.1
        let testPassword = testData.2
        let testNickname = testData.3
        
        modelView.email = testEmail
        modelView.password = testPassword
        modelView.loginAction(environmentData: environmentData)
        while modelView.isLoading {}
        
        if goodCredentials {
            try #require(modelView.isLoggedIn)
            //#expect(true)
            #expect(environmentData.userData.isLoggedIn && environmentData.userData.email == testEmail && environmentData.userData.nickname == testNickname)
        } else {
            try #require(!modelView.isLoggedIn)
            //#expect(true)
            #expect(!environmentData.userData.isLoggedIn && environmentData.userData.email == "" && environmentData.userData.nickname == "" && modelView.errorMessage == "Unauthorized: Invalid credentials")
        }
    }
    
    @Test("Check logout action", arguments: [
        (true, "a@a.a", "aaa", "Aaa"), // good
        (true, "user@example.com", "example_password", "example_user"), // good
        (false, "user@example.com", "wrong_password", "nickname"), // wrong
        (false, "wrong_email", "password", "nickname") // wrong
    ])
    func loggingOut(testData: (Bool, String, String, String)) async throws {
        setUp()
        let loginModelView: LoginViewModel = LoginViewModel()
        let logoutModelView: HomeViewModel = HomeViewModel()
        
        let goodCredentials = testData.0
        let testEmail = testData.1
        let testPassword = testData.2
        
        loginModelView.email = testEmail
        loginModelView.password = testPassword
        loginModelView.loginAction(environmentData: environmentData)
        while loginModelView.isLoading {}
        
        try #require(loginModelView.isLoggedIn == goodCredentials)
        logoutModelView.logoutAction(environmentData: environmentData)
        while (logoutModelView.isLoading) {}
        
        if goodCredentials {
            try #require(logoutModelView.logoutPerformed)
            #expect(!environmentData.userData.isLoggedIn && environmentData.userData.email == "" && environmentData.userData.nickname == "")
        } else {
            try #require(logoutModelView.error)
            #expect(logoutModelView.errorData!.errorDescription == APIError.unauthorized("unauthorized").errorDescription)
            
        }
    }
    
    @Test("Check fetching scan history", arguments: [
        (true,
        [
            ScanHistoryEntry(id: 5, timestamp: "2025.01.09 17:17:40"),
            ScanHistoryEntry(id: 2, timestamp: "2025.01.09 17:17:31")
        ]),
        
        (false,
        [])
    ])
    func fetchingScanHistory(testData: (Bool, [ScanHistoryEntry])) async throws {
        setUp()
        let loginModelView: LoginViewModel = LoginViewModel()
        let fetchScanHistoryViewModel: HomeViewModel = HomeViewModel()
        
        let authorizedUser = testData.0
        let testScanHistory = testData.1
        
        if (authorizedUser) {
            // logging in into known account
            loginModelView.email = "user@example.com"
            loginModelView.password = "example_password"
            loginModelView.loginAction(environmentData: environmentData)
            while (loginModelView.isLoading) {}
            try #require(loginModelView.isLoggedIn)
        }
        
        fetchScanHistoryViewModel.fetchScanHistoryData(environmentData: environmentData)
        while (fetchScanHistoryViewModel.isLoading) {}
        
        if (authorizedUser) {
            try #require(fetchScanHistoryViewModel.fetchingScanHistoryDataPerformed)
            #expect(testScanHistory == fetchScanHistoryViewModel.scanHistoryData)
        } else {
            try #require(fetchScanHistoryViewModel.error)
            #expect(fetchScanHistoryViewModel.errorData?.errorDescription == APIError.unauthorized("unauthorized").errorDescription)
        }
    }
    
    @Test("Check fetching full scan history", arguments: [
        ([
            ScanHistoryEntry(id: 5, timestamp: "2025.01.09 17:17:40"),
            ScanHistoryEntry(id: 2, timestamp: "2025.01.09 17:17:31")
        ],
        [FullScanHistoryEntry(id: 5, name: "orofar", description: "taki tam lek\n\n\n", image: "http://127.0.0.1:8080/uploads/prod_5.jpg", average_grade: 2.5, timestamp: "2025.01.09 17:17:40"),
         FullScanHistoryEntry(id: 2, name: "MacBookPro", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", image: "http://127.0.0.1:8080/uploads/image1.png", average_grade: 2.0, timestamp: "2025.01.09 17:17:31")
        ]),
        
        ([],
        []),
        
        ([
            ScanHistoryEntry(id: 1234567890987654321, timestamp: "2025.01.09 17:17:40")
        ],
        [])
    ])
    func fetchingFullScanHistory(testData: ([ScanHistoryEntry], [FullScanHistoryEntry])) async throws {
        setUp()
        let fetchFullScanHistoryViewModel: HomeViewModel = HomeViewModel()
        
        let testScanHistory = testData.0
        let testFullScanHistory = testData.1
        
        fetchFullScanHistoryViewModel.fetchFullScanHistoryData(environmentData: environmentData, scanHistoryList: testScanHistory)
        while (fetchFullScanHistoryViewModel.isLoading) {}
        
        try #require(fetchFullScanHistoryViewModel.fetchingFullScanHistoryDataPerformed)
        #expect(testFullScanHistory == fetchFullScanHistoryViewModel.fullScanHistoryData)
    }
    
    @Test("Check fetching user reviews", arguments: [
        (
            true,
            "a@a.a",
            "aaa",
            [
                ReviewData(id: 10, title: "Heheh", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 8, product_name: "Natalie", grade: 3.0, description: "Hahaha", price: 5.55, shop: ShopData(id: 5, name: "Polo"), media: []),
                ReviewData(id: 8, title: "Onions flavour is better", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 6, product_name: "czipery", grade: 2.0, description: "Fences", price: 28585.0, shop: ShopData(id: 6, name: "Rjdnfn"), media: [ReviewMediaData(id: 7, url: "http://127.0.0.1:8080/uploads/rev_8_7.jpg")]),
                ReviewData(id: 6, title: "Josh", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 4, product_name: "ABC", grade: 3.0, description: "Ufishdjwjs", price: 1.11, shop: ShopData(id: 4, name: "Appeals"), media: [ReviewMediaData(id: 5, url: "http://127.0.0.1:8080/uploads/rev_6_5.jpg")]),
                ReviewData(id: 5, title: "hahaha", user: UserData(id: 4, email: "a@a.a", nickname: "Aaa"), product_id: 5, product_name: "orofar", grade: 2.0, description: "jakshajbs", price: 6.66, shop: ShopData(id: 3, name: "Prima"), media: [])
            ]
        ),
        
        (
            true,
            "user@example.com",
            "example_password",
            [
                ReviewData(id: 3, title: "Fcsdfs", user: UserData(id: 1, email: "user@example.com", nickname: "example_user"), product_id: 2, product_name: "MacBookPro", grade: 2.0, description: "Gerfsgefsef", price: 11.11, shop: ReviewScanner.ShopData(id: 2, name: "Media Markt"), media: [ReviewMediaData(id: 3, url: "http://127.0.0.1:8080/uploads/rev_3_3.jpg")]),
                ReviewData(id: 2, title: "Fvsdefef", user: UserData(id: 1, email: "user@example.com", nickname: "example_user"), product_id: 3, product_name: "Abcdefg", grade: 1.0, description: "Gwrgrdfregr", price: 23.44, shop: ShopData(id: 2, name: "Media Markt"), media: [ReviewMediaData(id: 1, url: "http://127.0.0.1:8080/uploads/rev_2_1.jpg"), ReviewMediaData(id: 2, url: "http://127.0.0.1:8080/uploads/rev_2_2.jpg")])
            ]
        ),
        
        (
            false,
            "wrone_email",
            "wrong_password",
            []
        )
    ])
    func fetchingUserReviews(testData: (Bool, String, String, [ReviewData])) async throws {
        setUp()
        let loginViewModel: LoginViewModel = LoginViewModel()
        let fetchUserReviewsViewModel: UserReviewsViewModel = UserReviewsViewModel()
        
        let goodCredentials = testData.0
        let email = testData.1
        let password = testData.2
        let testReviews = testData.3
        
        if goodCredentials {
            loginViewModel.email = email
            loginViewModel.password = password
            loginViewModel.loginAction(environmentData: environmentData)
            while (loginViewModel.isLoading) {}
            try #require(loginViewModel.isLoggedIn)
        }
        
        fetchUserReviewsViewModel.actualiseReviews(environmentData: environmentData)
        while (fetchUserReviewsViewModel.isLoading) {}
        
        if goodCredentials {
            try #require(fetchUserReviewsViewModel.success)
            #expect(fetchUserReviewsViewModel.reviewData == testReviews)
        } else {
            try #require(fetchUserReviewsViewModel.error)
            #expect(fetchUserReviewsViewModel.errorData!.errorDescription == APIError.unauthorized("unauthorized").errorDescription)
        }
        
    }
    
        
}


struct LocalScanHistory_Tests {
    
    @Test("Check fetching local scan history", arguments: [
        [
            ScanHistoryEntry(id: 2, timestamp: "08.01.2025"),
            ScanHistoryEntry(id: 4, timestamp: "2025.01.22 12:01:56")
        ]
    ])
    func fetchingLocalScanHistory(testData: ([ScanHistoryEntry])) async throws {
        
        let testLocalScanHistory = testData
        let localScanHistory = getLocalScanHistory()
        
        #expect(testLocalScanHistory == localScanHistory)
    }
    
    @Test("Check merging into full scan history list", arguments: [
        (
            [
                ScanHistoryEntry(id: 2, timestamp: "2025.01.22 12:01:56"),
                ScanHistoryEntry(id: 1, timestamp: "2025.01.21 12:01:56"),
                ScanHistoryEntry(id: 3, timestamp: "2025.01.23 12:01:56")
            ],
            [
                ProductData(id: 2, name: "2", description: "2", image: "2", barcode: "2", average_grade: 2, grade_count: 2, reviews: []),
                ProductData(id: 1, name: "1", description: "1", image: "1", barcode: "1", average_grade: 1, grade_count: 1, reviews: []),
                ProductData(id: 3, name: "3", description: "3", image: "3", barcode: "3", average_grade: 3, grade_count: 3, reviews: [])
            ],
            [
                FullScanHistoryEntry(id: 3, name: "3", description: "3", image: "3", average_grade: 3, timestamp: "2025.01.23 12:01:56"),
                FullScanHistoryEntry(id: 2, name: "2", description: "2", image: "2", average_grade: 2, timestamp: "2025.01.22 12:01:56"),
                FullScanHistoryEntry(id: 1, name: "1", description: "1", image: "1", average_grade: 1, timestamp: "2025.01.21 12:01:56")
            ]
        ),
        
        (
            [
                ScanHistoryEntry(id: 3, timestamp: "2025.01.22 12:01:58"),
                ScanHistoryEntry(id: 2, timestamp: "2025.01.22 12:01:57"),
                ScanHistoryEntry(id: 1, timestamp: "2025.01.22 12:01:56")
            ],
            [
                ProductData(id: 3, name: "3", description: "3", image: "3", barcode: "3", average_grade: 3, grade_count: 3, reviews: []),
                ProductData(id: 2, name: "2", description: "2", image: "2", barcode: "2", average_grade: 2, grade_count: 2, reviews: []),
                ProductData(id: 1, name: "1", description: "1", image: "1", barcode: "1", average_grade: 1, grade_count: 1, reviews: [])
            ],
            [
                FullScanHistoryEntry(id: 3, name: "3", description: "3", image: "3", average_grade: 3, timestamp: "2025.01.22 12:01:58"),
                FullScanHistoryEntry(id: 2, name: "2", description: "2", image: "2", average_grade: 2, timestamp: "2025.01.22 12:01:57"),
                FullScanHistoryEntry(id: 1, name: "1", description: "1", image: "1", average_grade: 1, timestamp: "2025.01.22 12:01:56")
            ]
        ),
        
        (
            [
                ScanHistoryEntry(id: 3, timestamp: "2025.01.22 12:01:58"),
                ScanHistoryEntry(id: 2, timestamp: "2025.01.22 12:01:57"),
                ScanHistoryEntry(id: 1, timestamp: "2025.01.22 12:01:56")
            ],
            [
                ProductData(id: 3, name: "3", description: "3", image: "3", barcode: "3", average_grade: 3, grade_count: 3, reviews: []),
                ProductData(id: 2, name: "2", description: "2", image: "2", barcode: "2", average_grade: 2, grade_count: 2, reviews: []),
            ],
            [
                FullScanHistoryEntry(id: 3, name: "3", description: "3", image: "3", average_grade: 3, timestamp: "2025.01.22 12:01:58"),
                FullScanHistoryEntry(id: 2, name: "2", description: "2", image: "2", average_grade: 2, timestamp: "2025.01.22 12:01:57")
            ]
        ),
        
        (
            [],
            [
                ProductData(id: 3, name: "3", description: "3", image: "3", barcode: "3", average_grade: 3, grade_count: 3, reviews: []),
                ProductData(id: 2, name: "2", description: "2", image: "2", barcode: "2", average_grade: 2, grade_count: 2, reviews: []),
                ProductData(id: 1, name: "1", description: "1", image: "1", barcode: "1", average_grade: 1, grade_count: 1, reviews: [])
            ],
            []
        ),
        
        ([], [], [])
    ])
    func mergingIntoFullScanHistoryList(testData: ([ScanHistoryEntry], [ProductData], [FullScanHistoryEntry])) async throws {
        let viewModel: HomeViewModel = HomeViewModel()
        
        let scanHistoryList = testData.0
        let productsList = testData.1
        let testFullScanHistoryList = testData.2
        
        let fullScanHistoryList = viewModel.mergeIntoFullScanHistoryList(scanHistoryList: scanHistoryList, productDataList: productsList)
        
        #expect(testFullScanHistoryList == fullScanHistoryList)
    }
    
}
