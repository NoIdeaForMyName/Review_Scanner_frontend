//
//  TestFoundBarcode.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 28/11/2024.
//

import SwiftUI

struct TestFoundBarcodeView: View {
    let barcode: String
    
    var body: some View {
        Text(barcode)
            .font(.largeTitle)
    }
}

#Preview {
    TestFoundBarcodeView(barcode: "no barcode.")
}
