//
//  ProductNotFoundView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 29/12/2024.
//

import SwiftUI

struct ProductNotFoundView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    var barcode: String
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                
                Text("This product is currently not in our database.")
                    .font(.title)
                    .bold()
                    .padding(30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                if environmentData.userData.isLoggedIn {
                    SmallButton(text: "Add product", destination: AddProductView(barcode: barcode))
                }
                
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
    ProductNotFoundView(barcode: "1234567891011")
}
