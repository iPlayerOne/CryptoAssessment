//
//  CoinDetailHeaderView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import SwiftUI

struct DetailHeaderView: View {
    let coin: CoinListItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(coin.symbol)
                    .font(.headline)
            }
            if let imageUrl = URL(string: coin.imageUrl ?? "") {
                AsyncImage(url: imageUrl) { image in
                    switch image {
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
                        case .failure:
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                        @unknown default:
                            EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    DetailHeaderView(coin: MockData().coin)
}
