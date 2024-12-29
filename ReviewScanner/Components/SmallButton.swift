//
//  SmallButton.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 29/12/2024.
//

import SwiftUI

struct SmallButton<Destination: View>: View {
    let text: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 110, height: 50)
                    .foregroundColor(.button)
                
                Text(text)
                    .foregroundStyle(Color.black)
                    .padding()
            }

        }
    }
}

#Preview {
    NavigationView {
        SmallButton(text: "Add product", destination: EmptyView())
    }
}
