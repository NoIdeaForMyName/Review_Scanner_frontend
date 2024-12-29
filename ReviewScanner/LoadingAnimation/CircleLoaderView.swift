//
//  CircleLoader.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 29/12/2024.
//

import SwiftUI

struct CircleLoaderView: View {
    
    @State private var rotation: Double = 0
    
    private let lineWidth: Double = 10
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: self.lineWidth)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(.black)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1)
                    .repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    self.rotation = 360
                }
        }
        .compositingGroup()
        .frame(width: 125)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white
            .opacity(0.75))
        
        
    }
}

#Preview {
    CircleLoaderView()
}
