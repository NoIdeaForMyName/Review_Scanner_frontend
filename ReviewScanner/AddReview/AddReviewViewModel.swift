import Foundation
import Combine
import PhotosUI

class AddReviewViewModel: ObservableObject {
    @Published public var errorData: String? // Do przechowywania błędów logowania
    @Published public var addingReviewFinished: Bool = false
    @Published public var isLoading: Bool = false
    
    private var reviewAddingCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func addReviewAction(environmentData: EnvironmentData, productId: Int, rating: Int, title: String, price: Double, shopName: String, reviewBody: String, media: [UIImage]) {
        var isOk = false
        
        if rating < 1 {
            errorData = "Provide some rating!"
        } else if title.count < 2 {
            errorData = "Title too short"
        } else if price <= 0.0 {
            errorData = "Price should be positive number!"
        } else if shopName.count < 1 {
            errorData = "You should provide shop Name!"
        } else if reviewBody.count < 1 {
            errorData = "You should provide some description!"
        } else {
            isOk = true
        }
        
        if isOk {
            errorData = nil // Wyczyść poprzedni błąd
            isLoading = true
            
            reviewAddingCancellable = environmentData.authService.addReview(product_id: productId, title: title, description: reviewBody, grade: rating, price: price, shopName: shopName, images: media)
                .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Review added succesfully")
                        self?.addingReviewFinished = true
                    case .failure(let error):
                        self?.errorData = error.localizedDescription
                    }
                    self?.isLoading = false
                }, receiveValue: {})
        }
    }
    
}
