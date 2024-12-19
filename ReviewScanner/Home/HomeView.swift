import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Review Scanner")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                
                if environmentData.userData.isLoggedIn() {
                    Text("Hello \(environmentData.userData.nickname)")
                }
                else {
                    Text("Hello")
                }
                
                Spacer()
                
                MenuButton(iconName: "barcode.viewfinder", description: "Scan", nextView: BarcodeScannerView())
                
                MenuButton(iconName: "clock", description: "History", nextView: TestView())
                
                MenuButton(iconName: "person.circle", description: "Log In", nextView: LoginView())
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
        }
    }
}



#Preview {
    HomeView()
}
