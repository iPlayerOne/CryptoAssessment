//
//  СoinImageView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 17.1.25..
//

import SwiftUI

struct CoinImageView: View {
    let imageUrl: String
    
    var body: some View {
//        Image(systemName: "circle.fill")
//            .resizable()
//            .frame(width: 40, height: 40)
        if let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .transition(.scale)
                    case .failure:
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.gray)
                            .frame(width: 40, height: 40)
                            
                    @unknown default:
                        EmptyView()
                }
            }
        } else {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    CoinImageView(imageUrl: MockData().coin.imageUrl ?? "")
}
