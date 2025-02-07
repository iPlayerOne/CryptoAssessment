//
//  CryptoDetailView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import SwiftUI

struct CoinDetailView: View {
    @StateObject var vm: CoinDetailViewModel
    let coin: CoinListItem
    
    init(coin: CoinListItem) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coinId: coin.id))
    }
    
    var body: some View {
        VStack {
            if vm.coinDetails == nil {
                VStack {
                    ProgressView("Loading...")
                        .padding()
                }
            } else {
                content
            }
        }
        .task {
            vm.resetData()
            await vm.loadDetails()
        }
        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                DetailHeaderView(coin: coin)
            }
        }
    }
}

extension CoinDetailView {
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                    ChartView(coinId: coin.id)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 0)

                Text("Overview")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                LinksView(coinLinks: vm.coinDetails?.links)
                DescriptionView(attributedDescription: vm.attributedDescription)
                DetailAdditionalView(coin: coin)
            }
            .padding()
        }
    }
}

#Preview {

    let mockCoin = MockData().coin
    CoinDetailView(coin: mockCoin)
}
