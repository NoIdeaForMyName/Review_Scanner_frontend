import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Review Scanner")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                
                Text("Hello")
                
                Spacer()
                
                MenuButton(iconName: "barcode.viewfinder", description: "Scan", nextView: BarcodeScanner())
                
                MenuButton(iconName: "clock", description: "History", nextView: TestView())
                
                MenuButton(iconName: "person.circle", description: "Log In", nextView: TestView())
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
        }
    }
}



#Preview {
    HomePage()
}
