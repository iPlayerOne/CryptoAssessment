//
//  CoinDetails.swift
//  CryptoAssessment
//
//  Created by ikorobov on 12.1.25..
//
import Foundation

struct CoinDetails: Hashable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let description: Description?
    let links: Links?
    
    struct Description: Hashable, Decodable {
        let en: String?
    }
    
    struct Links: Hashable, Decodable {
           let homepage: [String]
           let twitterScreenName: String?
           let facebookUsername: String?
       }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case description
        case links
    }
}

struct MarketChartResponse: Decodable {
    let prices: [[Double]]
}
