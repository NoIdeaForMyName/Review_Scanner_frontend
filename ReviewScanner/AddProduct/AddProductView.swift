import SwiftUI
import Combine

struct AddProductView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    let barcode: String
    @StateObject var addProductViewModel: AddProductViewModel = AddProductViewModel()
    
    init(barcode: String) {
        self.barcode = barcode
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(spacing: 25) {
                    Text("Add product")
                    
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Adding product with barcode\n" + barcode)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.headline)
                            
                            HStack {
                                Text("Name")
                                    .frame(width: 85, alignment: .leading)
                                TextField("Product name", text: $addProductViewModel.name)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                            
                            Text("Description")
                            
                            TextEditor(text: $addProductViewModel.description)
                                .padding(8)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .frame(maxHeight: 200)
                            
                            Text("Main photo")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        
                        if let errorMessage = addProductViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                        Button(action: {
                            addProductViewModel.addProductAction(environmentData: environmentData, barcode: barcode)
                        }) {
                            Text("Add product")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.button)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .navigationDestination(isPresented: $addProductViewModel.isAdded) {
                            if let prodData = addProductViewModel.productData {
                                ProductPageView(productData: prodData)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                if addProductViewModel.isLoading {
                    CircleLoaderView()
                }
            }
        }
    }

}



#Preview {
    AddProductView(barcode: "1234567891011")
}
