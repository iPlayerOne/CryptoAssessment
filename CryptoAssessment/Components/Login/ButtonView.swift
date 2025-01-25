//
//  ButtonView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let textColor: Color
    let isEnabled: Bool
    
    
    public var body: some View {
        Button( action: {
            if isEnabled { action() }
        }) {
            Text(title)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(isEnabled ? textColor : .white)
                .background(isEnabled ? backgroundColor : .gray)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ButtonView(title: "Button", action: {}, backgroundColor: .red, textColor: .white, isEnabled: true)
}
