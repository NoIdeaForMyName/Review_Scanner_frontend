//
//  ProductPageViewModel.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 19/12/2024.
//

import Foundation
import Combine

class BarcodeScannerModelView: ObservableObject {
    @Published public var errorMessage: String? // Do przechowywania błędów logowania
    @Published public var productData: ProductData?
    @Published public var success: Bool = false

    private var productDataCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func fetchProductData(barcode: String) -> Void {
        errorMessage = nil // Wyczyść poprzedni błąd

        productDataCancellable = environmentData.guestService.fetchProductBarcode(barcode: barcode)
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Product data fetched successfully")
                    self?.success = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.success = false
                }
            }, receiveValue: { [weak self] prodData in
                self?.productData = prodData
            })
    }
    
}
