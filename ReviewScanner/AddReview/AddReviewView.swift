import SwiftUI
import Combine

struct AddReviewView: View {
    let productName: String
    
    @StateObject var addReviewViewModel: AddReviewViewModel = AddReviewViewModel()
    
    init(productId: Int, productName: String) {
        self.productName = productName
        addReviewViewModel.productId = productId
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Add review")
                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(productName)
                        
                        HStack {
                            Text("Rating")
                                .frame(width: 85, alignment: .leading)
                                .onTapGesture {
                                    addReviewViewModel.rating = 0
                                }
                            
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= addReviewViewModel.rating ? "star.fill" : "star")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(star <= addReviewViewModel.rating ? .yellow : .gray)
                                    .onTapGesture {
                                        addReviewViewModel.rating = star
                                    }
                            }
                        }
                        
                        HStack {
                            Text("Title")
                                .frame(width: 85, alignment: .leading)
                            TextField("Main thought", text: $addReviewViewModel.reviewTitle)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Price")
                                .frame(width: 85, alignment: .leading)
                            TextField("Price in a shop", text: $addReviewViewModel.price)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Shop")
                                .frame(width: 85, alignment: .leading)
                            TextField("Shop name", text: $addReviewViewModel.shop)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        Text("Description")
                        
                        TextEditor(text: $addReviewViewModel.shop)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .frame(maxHeight: 100)
                        
                        Text("Multimedia")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    
                    Button(action: {
                        addReviewViewModel.addReviewAction()
                    }) {
                        Text("Add review")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.button)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
        }
    }

}



#Preview {
    AddReviewView(productId: 1, productName: "MacBook Air")
}
