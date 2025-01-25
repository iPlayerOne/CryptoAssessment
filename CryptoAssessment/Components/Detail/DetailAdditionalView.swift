//
//  CoinDetailAdditionallView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import SwiftUI

struct DetailAdditionalView: View {
    let coin: CoinListItem
    
    var body: some View {
        Grid(alignment: .topLeading, horizontalSpacing: 20, verticalSpacing: 16) {
            GridRow {
                additionalDetail(title: "Current Price", value: "$" + (coin.priceUSD?.formattedAsCurrency() ?? "0"), percentChange: coin.percentChange24h)
                additionalDetail(title: "Market Cap.", value: coin.marketCap?.formattedAsCurrency() ?? "0", percentChange: coin.percentChange24h)
            }
            GridRow {
                additionalDetail(title: "Rank:", value: "#\(coin.rank)")
                additionalDetail(title: "Volume", value: "$" + (coin.volume?.formattedAsCurrency() ?? "0"))
            }
        }
    }
    
    private func additionalDetail(title: String, value: String, percentChange: Double? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.gray)
            Text(value)
                .font(.headline)
                .bold()
            if let change = percentChange {
                HStack(spacing: 4) {
                    Image(systemName: change >= 0 ? "arrow.up.circle" : "arrow.down.circle")
                        .foregroundStyle(change >= 0 ? Color.green : Color.red)
                    Text("\(String(format: "%.2f", abs(change)))%")
                        .foregroundStyle(change >= 0 ? Color.green : Color.red)
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value >= 1_000_000_000 {
            return "\(String(format: "%.2f", value / 1_000_000_000))B"
        } else if value >= 1_000_000 {
            return "\(String(format: "%.2f", value / 1_000_000))M"
        } else {
            return "\(String(format: "%.2f", value))"
        }
    }
}

#Preview {
    DetailAdditionalView(coin:
                            MockData().coin)
}
