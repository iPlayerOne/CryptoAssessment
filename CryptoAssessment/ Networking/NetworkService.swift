//
//  NetworkManager.swift
//  CryptoAssessment
//
//  Created by ikorobov on 27.12.24..
//

import Foundation

protocol NetworkService {
    func fetchCoins(retryCount: Int, forceRefresh: Bool) async throws -> [CoinListItem]
    func fetchCoinDetails(with coinId: String) async throws -> CoinDetails
    func fetchMarketChart(with coinId: String, days: Int) async throws -> [[Double]]
}


final class NetworkServiceImpl: NetworkService {
    private var cache: [CoinListItem] = []
    
    func fetchCoins(retryCount: Int = 3, forceRefresh: Bool = false) async throws -> [CoinListItem] {
        if !forceRefresh, !cache.isEmpty {
            return cache
        }
        
        let urlString = API.Endpoints.coinsURL()
        let request = makeRequest(url: urlString)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        let coins = try decodeJSON([CoinListItem].self, from: data)
        cache = coins
        return coins
    }
    
    func fetchCoinDetails(with  coinId: String) async throws -> CoinDetails {
        let urlString = "\(API.Endpoints.detailsURL(for: coinId))"
        let request = makeRequest(url: urlString)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        return try decodeJSON(CoinDetails.self, from: data)
        
    }
    
    func fetchMarketChart(with coinId: String, days: Int) async throws -> [[Double]] {
        let urlString = API.Endpoints.marketChartURL(for: coinId, days: days)
        print("Fetching market chart with URL: \(urlString)")
        let request = makeRequest(url: urlString)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        let coinChart = try decodeJSON(MarketChartResponse.self, from: data)
        return coinChart.prices
    }
    
    private func makeRequest(url: String) -> URLRequest {
        guard let url = URL(string: url) else {
            fatalError( "Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.addValue(API.apiKey, forHTTPHeaderField: "x-cg-demo-api-key")
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
         guard let httpResponse = response as? HTTPURLResponse else {
             throw URLError(.badURL)
         }
         
         switch httpResponse.statusCode {
             case 200..<300:
                 break
             case 429:
                 throw URLError(.timedOut, userInfo: ["message": "Exceeded retry limit"])
             default:
                 throw URLError(.badServerResponse, userInfo: ["statusCode": httpResponse.statusCode])
         }
     }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error decoding JSON: \(jsonString)")
            }
            throw error
        }
    }
 
}
