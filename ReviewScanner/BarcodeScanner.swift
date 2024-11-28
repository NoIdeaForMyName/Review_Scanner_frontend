import SwiftUI
import CodeScanner

struct BarcodeScanner: View {
    @State var barcode: String = ""
    @State var barcodeFound: Bool = false

    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.ean13],
            completion: { result in
                if case let .success(code) = result {
                    self.barcode = code.string
                    self.barcodeFound = true
                }
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Scanner")
                    .font(.title)
                    //.padding(.top)
                
                Spacer()
                
                self.scannerSheet
                    .background(Color.button, in: RoundedRectangle(cornerRadius: 50))
                
                Spacer()
                
                BarcodeManualEnter(infoText: "Doesn't work? Enter barcode manually:")
                
            }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                .navigationDestination(isPresented: $barcodeFound) {
                    TestFoundBarcode(barcode: barcode)
                }
        }

    }
}

#Preview {
    BarcodeScanner()
}
