import SwiftUI
import PhotosUI
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
    static let MAX_REVIEW_PHOTOS_COUNT = 5
    
    @EnvironmentObject var environmentData: EnvironmentData
    @StateObject var addReviewViewModel: AddReviewViewModel = AddReviewViewModel()
    
    let productId: Int
    let productName: String
    
    @State var rating: Int = 0
    @State var reviewTitle: String = ""
    @State var price: Double = 0
    @State var shopName: String = ""
    @State var reviewBody: String = ""
    @State var media: [UIImage] = []
    
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack() {
                    Text("Add review")
                    
                    ScrollView {
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
                                    .frame(minHeight: 100, maxHeight: 100)
                                
                                Text("Multimedia")
                                
                                VStack(alignment: .leading) {
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 20) {
                                            ForEach(0..<media.count, id: \.self) { i in
                                                Image(uiImage: media[i])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                            }
                                        }
                                    }
                                    
                                    PhotosPicker(selection: $photosPickerItems, maxSelectionCount: AddReviewView.MAX_REVIEW_PHOTOS_COUNT, selectionBehavior: .ordered, matching: .images) {
                                            Text("Select photos")
                                                .font(.headline)
                                                .padding()
                                                .background(Color.gradientBottom)
                                                .foregroundColor(.black)
                                                .cornerRadius(8)
                                    }
                                    .padding(.top)
                                }
                                .onChange(of: photosPickerItems) { _, _ in
                                    Task {
                                        if !photosPickerItems.isEmpty {
                                            media.removeAll()
                                        }
                                        
                                        for item in photosPickerItems {
                                            if let data = try? await item.loadTransferable(type: Data.self) {
                                                if let image = UIImage(data: data) {
                                                    media.append(image)
                                                }
                                            }
                                        }
                                        
                                        photosPickerItems.removeAll()
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            if let error = addReviewViewModel.errorData {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            
                            Button(action: {
                                addReviewViewModel.addReviewAction(environmentData: environmentData, productId: productId, rating: rating, title: reviewTitle, price: price, shopName: shopName, reviewBody: reviewBody, media: media)
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
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                
                if addReviewViewModel.isLoading {
                    CircleLoaderView()
                }
                
            }
            .navigationDestination(isPresented: $addReviewViewModel.addingReviewFinished) {
                InfoView(info: "Review added", nextView: HomeView())
            }
        }
    }

}



#Preview {
    AddReviewView(productId: 1, productName: "MacBook Air")
}
