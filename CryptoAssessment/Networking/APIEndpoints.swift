//
//  APIEndpoints.swift
//  CryptoAssessment
//
//  Created by ikorobov on 27.12.24..
//

import Foundation

struct API {
    static let baseURL = "https://api.coingecko.com/api/v3/"
    static var apiKey: String? {
        let key = Bundle.main.object(forInfoDictionaryKey: "COINGECKO_API_KEY") as? String
            ?? ProcessInfo.processInfo.environment["COINGECKO_API_KEY"]
        guard let key else { return nil }
        
        let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty, !trimmedKey.hasPrefix("$(") else {
            return nil
        }
        
        return trimmedKey
    }
    
    struct Endpoints {
        static let coins = "coins"
        static let markets = "coins/markets"
        
        static func coinsURL() -> String {
            return "\(baseURL)\(Endpoints.markets)?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
        }
        
        static func detailsURL(for id: String) -> String {
            return "\(baseURL)\(Endpoints.coins)/\(id)?localization=false"
        }
        
        static func marketChartURL(for id: String, days: Int) -> String {
            return "\(baseURL)\(coins)/\(id)/market_chart?vs_currency=usd&days=\(days)"
        }
    }
    
}
