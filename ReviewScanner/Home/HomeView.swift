import SwiftUI

struct HomeView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    @State private var isVideoPresented = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack {
                    
                    HStack {
                        Button(action: {
                            isVideoPresented = true
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.black)
                        }
                        
                        Spacer()
                        
                        if environmentData.userData.isLoggedIn {
                            Button(action: {
                                homeViewModel.logoutAction(environmentData: environmentData)
                            }){
                                Image(systemName: "arrow.left.circle")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                    
                    Text("Review Scanner")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    
                    if environmentData.userData.isLoggedIn {
                        Text("Hello \(environmentData.userData.nickname)")
                    }
                    else {
                        Text("Hello")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: BarcodeScannerView()) {
                        MenuButton(iconName: "barcode.viewfinder", description: "Scan")
                    }
                    
                    Button(action: {
                        if (environmentData.userData.isLoggedIn) {
                            homeViewModel.fetchScanHistoryData(environmentData: environmentData)
                        }
                        else {
                            let scanHistory = getLocalScanHistory()
//                            if let data = UserDefaults.standard.data(forKey: "scan-history"),
//                               let scanHistory = try? JSONDecoder().decode([ScanHistoryEntry].self, from: data) {
//                                homeViewModel.fetchFullScanHistoryData(environmentData: environmentData, scanHistoryList: scanHistory)
//                            } else {
//                                homeViewModel.fetchingFullScanHistoryDataPerformed = true
//                            }
                            homeViewModel.fetchFullScanHistoryData(environmentData: environmentData, scanHistoryList: scanHistory)
                        }
                    }) {
                        MenuButton(iconName: "clock", description: "History")
                    }
                    
                    if environmentData.userData.isLoggedIn {
                        NavigationLink(destination: UserReviewsView()) {
                            MenuButton(iconName: "star.bubble", description: "My reviews")
                        }
                    }
                    else {
                        NavigationLink(destination: LoginView()) {
                            MenuButton(iconName: "person.circle", description: "Log In")
                        }
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                .onAppear() {
                    homeViewModel.resetValues()
                    print("Is user logged in: \(environmentData.userData.isLoggedIn)")
                }
                
                .onChange(of: homeViewModel.fetchingScanHistoryDataPerformed) { _, fetched in
                    if fetched {
                        print("ndsauwdniwd")
                        homeViewModel.fetchFullScanHistoryData(environmentData: environmentData, scanHistoryList: homeViewModel.scanHistoryData)
                    }
                }
                
                if homeViewModel.isLoading {
                    CircleLoaderView()
                }
                
            }
            .navigationDestination(isPresented: $homeViewModel.logoutPerformed) {
                HomeView()
            }
            .navigationDestination(isPresented: $homeViewModel.fetchingFullScanHistoryDataPerformed) {
                RecentlyViewedProductsView(fullScanHistoryList: homeViewModel.fullScanHistoryData)
            }
            .navigationDestination(isPresented: $homeViewModel.error) {
                switch homeViewModel.errorData {
                case .networkingError:
                    Text("Networking error")
                default:
                    Text("Unknown error")
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isVideoPresented) {
            VideoPlayerView(isPresented: $isVideoPresented)
        }
    }
}



#Preview {
    HomeView()
}
