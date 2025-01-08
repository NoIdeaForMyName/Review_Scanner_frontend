import SwiftUI
import Combine

struct DecimalTextField: View {
    @Binding var value: Double
    let placeholder: String

    var body: some View {
        TextField(placeholder, value: $value, formatter: NumberFormatter.decimal)
            .keyboardType(.decimalPad)
    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // Maksymalna liczba miejsc po przecinku
        return formatter
    }
}

struct AddReviewView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    @StateObject var addReviewViewModel: AddReviewViewModel = AddReviewViewModel()
    
    let productId: Int
    let productName: String
    
    @State var rating: Int = 0
    @State var reviewTitle: String = ""
    @State var price: Double = 0
    @State var shopName: String = ""
    @State var reviewBody: String = ""
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack() {
                    Text("Add review")
                    
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(productName)
                            
                            HStack {
                                Text("Rating")
                                    .frame(width: 85, alignment: .leading)
                                    .onTapGesture {
                                        rating = 0
                                    }
                                
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(star <= rating ? .yellow : .gray)
                                        .onTapGesture {
                                            rating = star
                                        }
                                }
                            }
                            
                            HStack {
                                Text("Title")
                                    .frame(width: 85, alignment: .leading)
                                TextField("Main thought", text: $reviewTitle)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            HStack {
                                Text("Price")
                                    .frame(width: 85, alignment: .leading)
                                DecimalTextField(value: $price, placeholder: "")
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            HStack {
                                Text("Shop")
                                    .frame(width: 85, alignment: .leading)
                                TextField("Shop name", text: $shopName)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            Text("Description")
                            
                            TextEditor(text: $reviewBody)
                                .padding(8)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .frame(maxHeight: 100)
                            
                            Text("Multimedia") // TODO
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        
                        Button(action: {
                            addReviewViewModel.addReviewAction(environmentData: environmentData, productId: productId, rating: rating, title: reviewTitle, price: price, shopName: shopName, reviewBody: reviewBody, media: []) // media TODO
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
                
                .navigationDestination(isPresented: $addReviewViewModel.error) {
                    switch addReviewViewModel.errorData {
                    case .networkingError:
                        Text("Networking error")
                    default:
                        Text("Unknown error")
                    }
                }
                
                .navigationDestination(isPresented: $addReviewViewModel.addingReviewFinished) {
                    InfoView(info: "Review added", nextView: HomeView())
                }
                
                if addReviewViewModel.isLoading {
                    CircleLoaderView()
                }
                
            }
            
        }
    }

}



#Preview {
    AddReviewView(productId: 1, productName: "MacBook Air")
}
