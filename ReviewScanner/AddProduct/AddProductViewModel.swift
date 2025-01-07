import Foundation
import Combine
import PhotosUI

class AddProductViewModel: ObservableObject {
    var barcode: String? = nil
    
    @Published public var name: String = ""
    @Published public var description: String = ""
    @Published public var mainPhoto: UIImage? = nil

    public func addProductAction() {
        //TODO: add product action
    }
    
}

