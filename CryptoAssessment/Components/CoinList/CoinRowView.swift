//
//  CoinRowView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 28.12.24..
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinListItem
    
    var body: some View {
        HStack {
            if let imageUrl = coin.imageUrl {
                CoinImageView(imageUrl: imageUrl)
            }
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(coin.symbol)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(String(format: "%.2f", coin.priceUSD ?? 0.0))")
                    .font(.headline)
                Text("\(String(format: "%.2f", coin.percentChange24h ?? 0.0))% (24h)")
                    .font(.subheadline)
                    .foregroundColor(coin.percentChange24h ?? 0.0 >= 0 ? .green : .red)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    CoinRowView(coin: MockData().coin)
}
