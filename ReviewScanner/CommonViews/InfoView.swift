//
//  ProductNotFoundView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 08/01/2024.
//

import SwiftUI

struct InfoView<Destination: View>: View {
    
    let info: String
    let nextView: Destination
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                
                Text(info)
                    .font(.title)
                    .bold()
                    .padding(30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                SmallButton(text: "OK", destination: nextView)
                    
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
        }
    }
}

#Preview {
    InfoView(info: "Template info", nextView: Text("Next view"))
}
