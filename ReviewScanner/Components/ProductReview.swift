import SwiftUI

struct ProductReview: View {
    let upperLeftLabel: String = "Nickname"
    
    let reviewTitle: String
    let reviewBody: String
    let nickname: String
    let shop: String
    let price: Double
    let rating: Int
    let mediaURLs: [String]
    
    var body: some View {
        Review(reviewTitle: reviewTitle, reviewBody: reviewBody, upperLeftLabel: upperLeftLabel, upperLeftValue: nickname, shop: shop, price: price, rating: rating, mediaURLs: mediaURLs)
    }
}

#Preview {
    ProductReview(reviewTitle: "Review title", reviewBody: "This is the text of the review", nickname: "user1", shop: "Shop1", price: 99.99, rating: 4, mediaURLs: [
            "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D",
            "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ])
}
