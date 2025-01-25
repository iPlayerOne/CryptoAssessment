//
//  CoinModel.swift
//  CryptoAssessment
//
//  Created by ikorobov on 27.12.24..
//

import Foundation

struct CoinListItem: Hashable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let imageUrl: String?
    let priceUSD: Double?
    let percentChange24h: Double?
    let volume: Double?
    let marketCap: Double?
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case imageUrl = "image"
        case priceUSD = "current_price"
        case percentChange24h = "price_change_percentage_24h"
        case volume = "total_volume"
        case marketCap = "market_cap"
        case rank = "market_cap_rank"
    }
}
