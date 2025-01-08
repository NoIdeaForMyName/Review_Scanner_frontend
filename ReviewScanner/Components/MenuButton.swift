//
//  MenuButton.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import SwiftUI

struct MenuButton: View {
    let iconName: String
    let description: String
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 90))
                
                Text(description)
                
            }
            .foregroundStyle(.black)
            
            Spacer()
        }
        .padding()
        .background(Color.button, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NavigationView {
        MenuButton(iconName: "barcode.viewfinder", description: "Scan")
            .frame(maxHeight: .infinity)
            .background(Gradient(colors: gradientColors))
    }
}
