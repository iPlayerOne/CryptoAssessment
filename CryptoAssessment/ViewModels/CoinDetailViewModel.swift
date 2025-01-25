//
//  CoinDetailViewModel.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import SwiftUI

protocol CoinDetailViewModelContainer {
    func makeCryptoDetailViewModel(coin: CoinListItem) -> CoinDetailViewModel
}

final class CoinDetailViewModel: ObservableObject {
    @Published var marketChart: [ChartPoint] = []
    @Published var coinDetails: CoinDetails?
    @Published var attributedDescription: AttributedString?
    @Published var errorMessage: String?
    @Published var selectedRange: DateInterval = {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate
        return DateInterval(start: startDate, end: endDate)
    }()
    
    var maxRange: DateInterval {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate) ?? endDate
        return DateInterval(start: startDate, end: endDate)
    }
    
    var filteredChartData: [ChartPoint] {
        guard !marketChart.isEmpty else {
            print("[Warning] Market chart data is empty")
            return []
        }
       return marketChart.filter {
            $0.timestamp >= selectedRange.start && $0.timestamp <= selectedRange.end
        }
    }
    
    private let networkService: NetworkService
    private let coin: CoinListItem
    
    init(networkService: NetworkService, coin: CoinListItem) {
        self.networkService = networkService
        self.coin = coin
    }
    
    func loadDetails() async {
        do {
            let details = try await networkService.fetchCoinDetails(with: coin.id)
            await MainActor.run {
                self.coinDetails = details
                self.attributedDescription = self.parseHTML(details.description?.en)
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch coin details: \(error.localizedDescription)"
            }
        }
    }
    
    func loadChart(for days: Int) async {
        do {
            let rawData = try await networkService.fetchMarketChart(with: coin.id, days: days)
            let transformedData = transformToChartPoint(rawData)
            await MainActor.run {
                self.marketChart = transformedData
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch chart data: \(error.localizedDescription)"
            }
            
        }
    }
    
    func initializeData() async {
        await loadDetails()
        await loadChart(for: 30)
    }
    
    func resetData() {
        self.marketChart = []
        self.coinDetails = nil
        self.errorMessage = nil
    }
    
    private func transformToChartPoint(_ data: [[Double]]) -> [ChartPoint] {
        return data.compactMap { array in
            guard array.count == 2 else { return nil }
            let timestamp = Date(timeIntervalSince1970: array[0] / 1000)
            let price = array[1]
            return ChartPoint(timestamp: timestamp, price: price)
        }
    }
    
    private func parseHTML(_ html: String?) -> AttributedString? {
        guard let html = html else { return nil }
        return AttributedString(html: html)
    }
}
