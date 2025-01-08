//
//  RecentlyViewedProductsViewModel.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 08/01/2025.
//

import Foundation
import Combine

class RecentlyViewedProductsViewModel: ObservableObject {
    @Published public var errorData: APIError? // Do przechowywania błędów logowania
    @Published public var productData: ProductData?
    @Published public var success: Bool = false
    @Published public var error: Bool = false
    @Published public var isLoading: Bool = false

    private var productDataCancellable: AnyCancellable? // Do przechowywania subskrypcji
    

    public func fetchProductData(environmentData: EnvironmentData, id: Int) -> Void {
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true

        productDataCancellable = environmentData.guestService.fetchProductId(id: id)
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Product data fetched successfully")
                    self?.success = true
                case .failure(let error):
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] prodData in
                self?.productData = prodData
            })
    }
    
}
