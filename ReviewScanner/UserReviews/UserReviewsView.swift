import SwiftUI

struct UserReviewsView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    @StateObject var userReviewsModel: UserReviewsViewModel = UserReviewsViewModel()
    
    var body: some View {
        ZStack{
            VStack() {
                Text("My reviews")
                
                ScrollView {
                    VStack(spacing: 20) {
                        if userReviewsModel.success {
                            VStack {
                                ForEach(userReviewsModel.reviewData, id: \.id) { reviewData in
                                    UserReview(
                                        reviewTitle: reviewData.title,
                                        reviewBody: reviewData.description,
                                        productName: reviewData.product_name,
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
                        } else if let error = userReviewsModel.errorData {
                            switch error {
                            case .notFound:
                                Text("User didn't write any review yet.")
                                    .font(.title)
                                    .bold()
                                    .padding(30)
                                    .multilineTextAlignment(.center)
                            default:
                                Text(error.localizedDescription)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Gradient(colors: gradientColors))
            
            if userReviewsModel.isLoading {
                CircleLoaderView()
            }
        }
        .onAppear {
            userReviewsModel.actualiseReviews(environmentData: environmentData)
        }
    }
}

//#Preview {
//    UserReviewsView(
//        reviews: [
//            UserReview(
//                reviewTitle: "Review 1",
//                reviewBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
//                productName: "MacBook Pro",
//                shop: "shop1",
//                price: 4.99,
//                rating: 1,
//                mediaURLs: [
//                    "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D",
//                    "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
//                ]
//            ),
//            UserReview(
//                reviewTitle: "Review 2",
//                reviewBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
//                productName: "MacBook Air",
//                shop: "shop2",
//                price: 199.99,
//                rating: 5,
//                mediaURLs: [
//                    "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D"
//                ]
//            )
//        ]
//    )
//
//}

