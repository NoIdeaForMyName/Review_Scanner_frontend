//
//  ProductNotFoundView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 29/12/2024.
//

import SwiftUI

struct ProductNotFoundView: View {
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                
                Text("This product is currently not in our database. Do you want to add it?")
                    .font(.title)
                    .bold()
                    .padding(30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // TODO: pass actual barcode
                SmallButton(text: "Add product", destination: AddProductView(barcode: "1234567891011"))
                
                SmallButton(text: "Cancel", destination: HomeView())
                    
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
        }
    }
}

#Preview {
    ProductNotFoundView()
}
