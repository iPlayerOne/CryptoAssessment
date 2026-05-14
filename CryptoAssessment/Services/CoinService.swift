//
//  CoinService.swift
//  CryptoAssessment
//
//  Created by ikorobov on 27.12.24..
//


protocol CoinService {
    func fetchCoins(forceRefresh: Bool) async throws -> [CoinListItem]
    func fetchCoinDetails(with coinId: String) async throws -> CoinDetails
    func fetchMarketChart(with coinId: String, days: Int) async throws -> [[Double]]
}

final class CoinServiceImpl: CoinService {
    private let networkService: NetworkService
    private var coinCache: [CoinListItem] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    

    func fetchCoins(forceRefresh: Bool) async throws -> [CoinListItem] {
        if !forceRefresh, !coinCache.isEmpty {
            return coinCache
        }
        
        let endpoint = API.Endpoints.coinsURL()
        let coins: [CoinListItem] = try await networkService.request(endpoint: endpoint)
        
        coinCache = coins
        return coins
    }
    
    func fetchCoinDetails(with coinId: String) async throws -> CoinDetails {
        let endpoint = API.Endpoints.detailsURL(for: coinId)
        return try await networkService.request(endpoint: endpoint)
        
    }
    
    func fetchMarketChart(with coinId: String, days: Int) async throws -> [[Double]] {
        let endpoint = API.Endpoints.marketChartURL(for: coinId, days: days)
        let marketChart: MarketChartResponse = try await networkService.request(endpoint: endpoint)
        
        return marketChart.prices
    }
    
    
}

