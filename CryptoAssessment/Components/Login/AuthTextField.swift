//
//  AuthTextField.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct AuthTextField: View {
    @State var isTextVisitible: Bool = false
    
    let title: String
    @Binding var text: String
    let isSecure: Bool
    let hasError: Bool
    
   
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(hasError ? Color.red : Color.gray, lineWidth: 1)
                .frame(height: 50)
            HStack {
                if isSecure && !isTextVisitible {
                    SecureField(title, text: $text)
                        .padding(.leading, 10)
                } else {
                    TextField(title, text: $text)
                        .padding(.leading, 10)
                }
                
                if isSecure {
                    Button(action: {
                        isTextVisitible.toggle()
                    }) {
                        Image(systemName: isTextVisitible ? "eye.slash" : "eye")
                            .foregroundColor(Color.gray)
                    }
                    .padding(.trailing, 10)
                }
            }
            .frame(height: 50)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AuthTextField(title: "Title", text: .constant(""), isSecure: false, hasError: false)
}
