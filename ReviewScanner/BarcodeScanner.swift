import SwiftUI
import AVFoundation

struct BarcodeScanner: View {
    @State private var scannedCode: String? = nil
    @State private var isScanning: Bool = true
    
    var body: some View {
        VStack {
            Text("Scanner")
                .font(.title)
                //.padding(.top)
            
            Spacer()
            
            if isScanning {
                ScannerView(scannedCode: $scannedCode, isScanning: $isScanning)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
            } else if let code = scannedCode {
                Text("Scanned Code: \(code)")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                isScanning = true
                scannedCode = nil
            }) {
                Text("Restart Scanner")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.button)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
    }
}

#Preview {
    BarcodeScanner()
}
