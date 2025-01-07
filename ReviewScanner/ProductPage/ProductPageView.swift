import SwiftUI

struct ProductPageView: View {
//    let productName: String
//    let productImageURL: String
//    let reviewAverage: String
//    let productDescription: String
//    let reviews: [ProductReview]
    @EnvironmentObject var environmentData: EnvironmentData

    let productData: ProductData
    
    @StateObject var productPageViewModel: ProductPageModelView = ProductPageModelView()
    
    @State private var isDescriptionExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: productData.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipped()
                            .cornerRadius(30)
                    case .failure:
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                HStack() {
                    Image(systemName: "star")
                    
                    Text(String(format: "%.1f", productData.average_grade))
                    
                    Text(productData.name)
                        .font(.headline)
                }
                
                VStack(alignment: .leading) {
                    Text(productData.description)
                        .lineLimit(isDescriptionExpanded ? nil : 5)
                        .animation(.easeInOut, value: isDescriptionExpanded)
                    
                    Button(action: {
                        isDescriptionExpanded.toggle()
                    }) {
                        Text(isDescriptionExpanded ? "Show Less" : "Show More")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Button(action: {
                    // TODO: add review
                }) {
                    Text("Add review")
                        .font(.headline)
                        .padding()
                        .background(Color.button)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                
                VStack {
                    ForEach(productData.reviews, id: \.id) { reviewData in
                        ProductReview(
                            reviewTitle: reviewData.title,
                            reviewBody: reviewData.description,
                            nickname: reviewData.user.nickname,
                            shop: reviewData.shop.name,
                            price: reviewData.price,
                            rating: Int(reviewData.grade),
                            mediaURLs: reviewData.media.map { $0.url }
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Gradient(colors: gradientColors))
        
        .onAppear() {
            if productData.id == -1 {
                return
            }
            
            else if environmentData.userData.isLoggedIn {
                // TODO implementacja dodania historii skanów na serwer
            }
            
            else {
                productPageViewModel.addLocalScanHistoryEntry(productData: productData)
            }
        }

    }
}

#Preview {
    //ProductPageView(barcode: "1234567890123")
    
//    ProductPageView(
//        productName: "MacBook Pro",
//        productImageURL: "https://images.unsplash.com/photo-1719937206168-f4c829152b91?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//        reviewAverage: "4.8",
//        productDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        reviews: [
//            ProductReview(
//                reviewTitle: "Review 1",
//                reviewBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
//                nickname: "user1",
//                shop: "shop1",
//                price: "4.99",
//                rating: 1,
//                mediaURLs: [
//                    "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D",
//                    "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
//                ]
//            ),
//            ProductReview(
//                reviewTitle: "Review 2",
//                reviewBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
//                nickname: "user2",
//                shop: "shop2",
//                price: "199.99",
//                rating: 5,
//                mediaURLs: [
//                    "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D"
//                ]
//            )
//        ]
//    )

}

