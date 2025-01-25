//
//  LinkButton.swift
//  CryptoAssessment
//
//  Created by ikorobov on 11.1.25..
//

import SwiftUI

struct LinkButton: View {
    let imageName: String
    let url: String?
    
    var body: some View {
        Button(action: {
            if let url = url, let destination = URL(string: url) {
                UIApplication.shared.open(destination)
            }
        }) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width:24, height: 24)
                .padding(10)
                .background( url != nil ? Color.black : Color.gray )
                .cornerRadius(15)
        }
        .disabled(url == nil)
    }
}

#Preview {
    LinkButton(imageName: "bird", url: "")
}
