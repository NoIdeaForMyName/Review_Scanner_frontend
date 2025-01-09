//
//  UserReviewsViewModel.swift
//  ReviewScanner
//
//  Created by m1 on 08/01/2025.
//

import Foundation
import Combine

class UserReviewsViewModel: ObservableObject {
    @Published public var errorData: APIError? // Do przechowywania błędów logowania
    @Published public var reviewData: [ReviewData] = []
    @Published public var productData: ProductData?
    @Published public var success: Bool = false
    @Published public var successProd: Bool = false
    @Published public var error: Bool = false
    @Published public var isLoading: Bool = false

    private var productDataCancellable: AnyCancellable? // Do przechowywania subskrypcji
    

    public func actualiseReviews(environmentData: EnvironmentData) -> Void {
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true

        productDataCancellable = environmentData.authService.fetchMyReviews()
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Product data fetched successfully")
                    self?.success = true
                case .failure(let error):
                    self?.success = false
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] revData in
                self?.reviewData = revData
            })
    }
    
    public func fetchProductData(environmentData: EnvironmentData, id: Int) -> Void {
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true

        productDataCancellable = environmentData.guestService.fetchProductId(id: id)
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Product data fetched successfully")
                    self?.successProd = true
                case .failure(let error):
                    self?.successProd = false
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] prodData in
                self?.productData = prodData
            })
    }
    
}
