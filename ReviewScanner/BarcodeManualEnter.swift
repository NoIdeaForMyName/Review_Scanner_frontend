//
//  BarcodeManualEnter.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 28/11/2024.
//

import SwiftUI

struct BarcodeManualEnter: View {
    let infoText: String
    
    @State private var barcode: [String] = Array(repeating: "", count: 13) // 13 pól na cyfry
    
    // spacing after 1 and 7 idx
    var spacingIdx: [Int] = [1, 7]
    
    var body: some View {
        
        VStack {
            Text(infoText)
                //.font(.caption2)
            
            HStack(spacing: 5) {
                ForEach(0..<13, id: \.self) { index in
                    if spacingIdx.contains(index) {
                        Spacer()
                    }
                    VStack {
                        // Pole tekstowe na cyfrę
                        TextField("", text: $barcode[index])
                        //.frame(width: 30, height: 40)
                            //.multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onChange(of: barcode[index]) { newValue in
                                // Ograniczenie do jednej cyfry
                                if newValue.count > 1 {
                                    barcode[index] = String(newValue.prefix(1))
                                }
                                // Usuwanie niedozwolonych znaków
                                if !newValue.allSatisfy({ $0.isNumber }) {
                                    barcode[index] = ""
                                }
                            }
                        
                        // Linia pod polem tekstowym
                        Text("_")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.button, in: RoundedRectangle(cornerRadius: 50))
        
    }
}

#Preview {
    BarcodeManualEnter(infoText: "Doesn't work? Enter barcode manually:")
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
}
