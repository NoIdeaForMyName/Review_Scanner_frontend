import SwiftUI

struct HomeView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                //if environmentData.userData.isLoggedIn {
                if environmentData.userData.isLoggedIn {
                    HStack {
                        Spacer()
                        NavigationLink(destination: HomeView()) {
                            Button(action: {
                                homeViewModel.logoutAction(environmentData: environmentData)
                            }){
                                Image(systemName: "arrow.left.circle")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.black)
                            }
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
                
                MenuButton(iconName: "barcode.viewfinder", description: "Scan", nextView: BarcodeScannerView())
                
                MenuButton(iconName: "clock", description: "History", nextView: TestView())

                if environmentData.userData.isLoggedIn {
                    MenuButton(iconName: "star.bubble", description: "My reviews", nextView: UserReviewsView(reviews: []))
                }
                else {
                    MenuButton(iconName: "person.circle", description: "Log In", nextView: LoginView())
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
            
            .navigationDestination(isPresented: $homeViewModel.logoutPerformed) {
                HomeView()
            }
            .onAppear() {
                print("Is user logged in: \(environmentData.userData.isLoggedIn)")
            }
        }
    }
}



#Preview {
    HomeView()
}
