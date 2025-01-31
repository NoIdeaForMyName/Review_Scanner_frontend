import Foundation
import Combine
import PhotosUI

class AddProductViewModel: ObservableObject {
    @Published public var name: String = ""
    @Published public var description: String = ""
    @Published public var mainPhoto: UIImage?
    @Published public var errorMessage: String? // Do przechowywania błędów logowania
    @Published public var isLoading: Bool = false
    @Published public var isAdded: Bool = false
    
    public var productData: ProductData? = nil
    private var addProductCancellable: AnyCancellable?
    
    public func addProductAction(environmentData: EnvironmentData, barcode: String) {
        var isOk = false
        
        if name.count < 2 {
            errorMessage = "Name too short"
        } else if mainPhoto == nil {
            errorMessage = "Provide one photo!"
        } else {
            isOk = true
        }
        
        if isOk {
            errorMessage = nil // Wyczyść poprzedni błąd
            isLoading = true
            
            let timestamp = getCurrentDateString()
            
            addProductCancellable = environmentData.authService.addProduct(barcode: barcode, name: name, description: description, image: mainPhoto!)
                .flatMap { [barcode, timestamp] in
                    environmentData.authService.addToHistory(barcode: barcode, timestamp: timestamp)
                }
                .flatMap { [barcode] in  // Chain with the second request
                    environmentData.guestService.fetchProductBarcode(barcode: barcode)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Product data fetched successfully")
                        self?.isAdded = true
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.isLoading = false
                }, receiveValue: { [weak self] prodData in
                    self?.productData = prodData
                })
        }
        
    }
    
}
