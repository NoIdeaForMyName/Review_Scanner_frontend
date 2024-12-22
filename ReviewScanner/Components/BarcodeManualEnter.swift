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
    @State var assigner: (String) -> Void
    //@State var barcodeEntered = false
    
    // spacing after 1 and 7 idx
    var spacingIdx: [Int] = [1, 7]
    
    @FocusState private var focusedIndex: Int?
        
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text(infoText)
                    .font(.system(size: 22))
                    .padding(.bottom, 10)
                
                HStack(spacing: 5) {
                    ForEach(0..<13, id: \.self) { index in
                        if spacingIdx.contains(index) {
                            Spacer()
                        }
                        VStack {
                            TextField("_", text: $barcode[index])
                                .focused($focusedIndex, equals: index)
                                .keyboardType(.numberPad)
                                .onChange(of: barcode[index]) {
                                    barcodeValueChanged(currIdx: index)
                                }
                            
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding()
            .background(Color.button, in: RoundedRectangle(cornerRadius: 50))
//            .frame(maxHeight: .infinity)
//            .background(Gradient(colors: gradientColors))
            
//            .navigationDestination(isPresented: $barcodeEntered) {
//                ProductPageView(barcode: barcodeToString(barcode))
//            }
            
//            .onChange(of: barcodeEntered) { found in
//                if found {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        barcode_str = ""
//                        barcodeEntered = false
//                    }
//                }
//            }
            
        }
        
    }
    
    func barcodeValueChanged(currIdx: Int) -> Void {
        var entered = barcode[currIdx]
        entered = entered.count > 2 ? String(entered.prefix(2)) : entered
        
        if entered.count < 2 {
            if !entered.allSatisfy({ $0.isNumber }) {
                entered = ""
            }
            barcode[currIdx] = entered
            
            if entered.isEmpty {
                focusedIndex = currIdx - 1
            }
            
            if currIdx == barcode.count - 1 {
                barcodeCompleted()
            }
        }
        else if !entered.isEmpty && currIdx + 1 <= barcode.count - 1 {
            barcode[currIdx] = String(entered.first!)
            barcode[currIdx + 1] = String(entered.last!)
            focusedIndex = currIdx + 1 // Przejdź do następnego pola
        }
    }
    
    func barcodeCompleted() -> Void {
        assigner(barcode.joined(separator: ""))
    }
    
}

#Preview {
    //BarcodeManualEnter(infoText: "Doesn't work? Enter barcode manually:")
}
