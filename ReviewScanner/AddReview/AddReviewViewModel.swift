import Foundation
import Combine
import PhotosUI

class AddReviewViewModel: ObservableObject {
    var productId: Int? = nil
    
    @Published public var rating: Int = 0
    @Published public var reviewTitle: String = ""
    @Published public var price: String = ""
    @Published public var shop: String = ""
    @Published public var reviewBody: String = ""
    @Published public var media: [UIImage] = []

    public func addReviewAction() {
        //TODO: add review action
    }
    
}
