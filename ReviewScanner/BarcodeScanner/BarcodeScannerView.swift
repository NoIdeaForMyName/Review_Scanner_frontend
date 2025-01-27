import SwiftUI
import CodeScanner

struct BarcodeScannerView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    @State var barcode: String = ""
    @State var barcodeFound: Bool = false
    
    @StateObject var barcodeScannerViewModel: BarcodeScannerModelView = BarcodeScannerModelView()
    @State var productPageReady = false

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
    
    var manualEnterSheet: some View {
        BarcodeManualEnter(
            infoText: "Doesn't work? Enter barcode manually:",
            assigner: { code in
                self.barcode = code
                self.barcodeFound = true
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack(spacing: 20) {
                    Text("Scanner")
                        .font(.title)
                    //.padding(.top)
                    
                    Spacer()
                    
                    self.scannerSheet
                        .background(Color.button, in: RoundedRectangle(cornerRadius: 50))
                    
                    Spacer()
                    
                    self.manualEnterSheet
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Gradient(colors: gradientColors))
                
                .onChange(of: barcodeFound) { _, found in
                    if found {
                        barcodeScannerViewModel.playScannerSound()
                        barcodeScannerViewModel.fetchProductData(environmentData: environmentData, barcode: barcode)
                    }
                }
                
                if barcodeScannerViewModel.isLoading {
                    CircleLoaderView()
                }
                
            }
            .navigationDestination(isPresented: $barcodeScannerViewModel.success) {
                ProductPageView(productData: barcodeScannerViewModel.productData ?? ProductData(id: -1, name: "test", description: "test", image: "", barcode: "123", average_grade: 5, grade_count: 1, reviews: []))
                //TestFoundBarcodeView(barcode: barcode)
            }
            
            .navigationDestination(isPresented: $barcodeScannerViewModel.error) {
                switch barcodeScannerViewModel.errorData {
                case .notFound:
                    ProductNotFoundView(barcode: barcode)
                default:
                    if let error = barcodeScannerViewModel.errorData {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                
            }
        }

    }
}

#Preview {
    BarcodeScannerView()
}
