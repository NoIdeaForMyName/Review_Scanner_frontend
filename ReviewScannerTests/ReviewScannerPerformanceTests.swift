@testable import ReviewScanner
import Combine
import XCTest

final class ReviewScannerPerformanceTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    let guestService: GuestServiceProtocol = API_GuestService()
    let authService: AuthServiceProtocol = API_AuthService()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductInfoFetchingByBarcodePerformance() throws {
        self.measure {
            let expectation = self.expectation(description: "Fetch product barcode completes")
            
            guestService.fetchProductBarcode(barcode: TestConstants.validBarcode)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            XCTFail("Fetch failed with error: \(error)")
                        }
                        expectation.fulfill()
                    },
                    receiveValue: { productData in
                        XCTAssertNotNil(productData)
                    }
                )
                .store(in: &self.cancellables)
            
            wait(for: [expectation], timeout: 20.0)
        }
    }
    
    func testProductInfoFetchingByIdPerformance() throws {
        self.measure {
            let expectation = self.expectation(description: "Fetch product id completes")
            
            guestService.fetchProductId(id: TestConstants.validProductIds.randomElement()!)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            XCTFail("Fetch failed with error: \(error)")
                        }
                        expectation.fulfill()
                    },
                    receiveValue: { productData in
                        XCTAssertNotNil(productData)
                    }
                )
                .store(in: &self.cancellables)
            
            wait(for: [expectation], timeout: 20.0)
        }
    }
    
    func testMultipleProductsInfoFetchingByIdPerformance() throws {
        self.measure {
            let expectation = self.expectation(description: "Fetch product ids completes")
            
            guestService.fetchProductsIds(ids: TestConstants.validProductIds)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            XCTFail("Fetch failed with error: \(error)")
                        }
                        expectation.fulfill()
                    },
                    receiveValue: { productsData in
                        for productData in productsData {
                            XCTAssertNotNil(productData)
                        }
                    }
                )
                .store(in: &self.cancellables)
            
            wait(for: [expectation], timeout: 20.0)
        }
    }

}
