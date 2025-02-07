//
//  CoinsListView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct CoinsListView: View {
    @StateObject private var vm = CoinListViewModel()
    
    init() {
        print("CoinsListView initialized")
    }
    
    var body: some View {
        Group {
            switch vm.state {
                case .loading:
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                case .loaded(let coins):
                    List(coins, id: \.id) { coin in
                        CoinRowView(coin: coin)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.selectCoin(coin)
                            }
                            .transition(.opacity)
                    }
                    .listStyle(PlainListStyle())
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 0)
                    }
                    .refreshable {
                        Task {
                            try await Task.sleep(nanoseconds: 200_000_000)
                            await vm.fetchCoins(forceRefresh: true)
                        }
                        
                    }
                case .failed(let errorMessage):
                    VStack {
                        Text("Failed to load coins")
                            .font(.headline)
                            .foregroundStyle(Color.red)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await vm.fetchCoins()
                            }
                        }
                        .padding(.top, 16)
                    }
            }
        }
        .searchable(text: $vm.searchQuery)
        .task {
                await vm.fetchCoins()
        }
        .navigationTitle("Coins")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                SortingMenu(selectedOption: $vm.sortedBy) { newOption in
                    vm.changeSortingOption(to: newOption)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    vm.logout()
                }
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    CoinsListView()
}
