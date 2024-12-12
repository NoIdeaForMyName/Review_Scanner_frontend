import SwiftUI

struct ReviewView: View {
    let reviewTitle: String
    let reviewBody: String
    let upperLeftLabel: String
    let upperLeftValue: String
    let shop: String
    let price: String
    let rating: Int
    let mediaURLs: [String]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack() {
                    Text("\(upperLeftLabel): \(upperLeftValue)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("Price: \(String(describing: price))$")
                        .font(.subheadline)
                }.padding(.bottom, 10)
                
                HStack() {
                    Text("Shop name: \(shop)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    ForEach(0..<5) { index in
                        Image(systemName: index < rating ? "star.fill" : "star")
                            .foregroundColor(index < rating ? .yellow : .gray)
                    }
                }.padding(.bottom, 10)
                
                HStack() {
                    ForEach(mediaURLs, id: \.self) { mediaURL in
                        AsyncImage(url: URL(string: mediaURL)) { phase in
                            switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                        .cornerRadius(10)
                                case .failure:
                                    Image(systemName: "xmark.octagon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                @unknown default:
                                    EmptyView()
                                }
                        }
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.top, 10)
            
            VStack() {
                Text(reviewTitle)
                    .font(.title)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 5)
                Text(reviewBody)
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    ReviewView(reviewTitle: "Review title", reviewBody: "This is the text of the review", upperLeftLabel: "Nickname/Product name", upperLeftValue: "u1/p1", shop: "Shop1", price: "99.99", rating: 4, mediaURLs: [
            "https://images.unsplash.com/photo-1600262300671-295cb21f4d06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D",
            "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ])
}
