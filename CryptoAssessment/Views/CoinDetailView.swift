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
    
    init(container: AppContainer, coin: CoinListItem) {
        self.coin = coin
        _vm = StateObject(wrappedValue: container.makeCryptoDetailViewModel(coin: coin))
        print("CoinDetailView for \(coin.name) initialized")
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
            await vm.initializeData()
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
                if !vm.filteredChartData.isEmpty  {
                    ChartView(
                        selectedRange: $vm.selectedRange,
                        chartData: vm.filteredChartData,
                        maxRange: vm.maxRange
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 0)
                } else {
                    ProgressView()
                }
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
    let container = AppContainer()
    let mockCoin = MockData().coin
    CoinDetailView(container: container, coin: mockCoin)
}
