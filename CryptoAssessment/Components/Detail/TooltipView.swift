//
//  TooltipView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 11.1.25..
//

import SwiftUI

struct TooltipView: View {
    let position: CGPoint
    let price: Double
    let date: Date
    
    var body: some View {
        VStack(spacing: 4) {
            Text(price, format: .currency(code: "USD"))
                .font(.caption)
                .foregroundStyle(.white)
            
            Text(date, style: .date)
                .font(.caption)
                .foregroundStyle(.white)
        }
        .padding(8)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .frame(width: 150)
        .position(position)
        
        
        
    }
}

#Preview {
    TooltipView(position: CGPoint(x: 100, y: 10), price: 100, date: Date())
}
