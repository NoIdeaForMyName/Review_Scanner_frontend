import Foundation
import Combine
import PhotosUI

class AddReviewViewModel: ObservableObject {
    @Published public var errorData: APIError? // Do przechowywania błędów logowania
    @Published public var error: Bool = false
    @Published public var addingReviewFinished: Bool = false
    @Published public var isLoading: Bool = false
    
    private var reviewAddingCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func addReviewAction(environmentData: EnvironmentData, productId: Int, rating: Int, title: String, price: Double, shopName: String, reviewBody: String, media: [UIImage]) {
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
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: {})
    }
    
}
