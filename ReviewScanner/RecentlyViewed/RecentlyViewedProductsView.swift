import SwiftUI

struct RecentlyViewedProductsView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    @StateObject var recentlyViewedProductsViewModel: RecentlyViewedProductsViewModel = RecentlyViewedProductsViewModel()
    
    let fullScanHistoryList: [FullScanHistoryEntry]
    
    var body: some View {
        NavigationStack {
            ZStack() {
                VStack() {
                    Text("Recently viewed products")
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            VStack {
                                ForEach(0..<fullScanHistoryList.count, id: \.self) { index in
                                    Button(action: {
                                        recentlyViewedProductsViewModel.fetchProductData(environmentData: environmentData, id: fullScanHistoryList[index].id)
                                    }) {
                                        Product(fullScanHistoryEntry: fullScanHistoryList[index])
                                    }
                                }
                            }
                            .shadow(radius: 5)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .background(Gradient(colors: gradientColors))
                
                .navigationDestination(isPresented: $recentlyViewedProductsViewModel.success) {
                    ProductPageView(productData: recentlyViewedProductsViewModel.productData ?? ProductData(id: -1, name: "test", description: "test", image: "", barcode: "123", average_grade: 5, grade_count: 1, reviews: []))
                }
                
                .navigationDestination(isPresented: $recentlyViewedProductsViewModel.error) {
                    switch recentlyViewedProductsViewModel.errorData {
                    case .networkingError:
                        Text("Networking error")
                    default:
                        Text("Unknown error")
                    }
                    
                }
                
                if recentlyViewedProductsViewModel.isLoading {
                    CircleLoaderView()
                }
            }
        }
    }
}

#Preview {
    RecentlyViewedProductsView(
        fullScanHistoryList: [
            FullScanHistoryEntry(
                id: 1234567890123,
                name: "MacBook Pro",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                image: "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                average_grade: 4.7,
                timestamp: "01.01.2025"),
            FullScanHistoryEntry(
                id: 1234567890123,
                name: "MacBook Air",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                image: "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                average_grade: 4.8,
                timestamp: "01.01.2025"),
            FullScanHistoryEntry(
                id: 1234567890123,
                name: "MacBook Pro Max",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                image: "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                average_grade: 4.8,
                timestamp: "01.01.2025")
        ]
    )

}

