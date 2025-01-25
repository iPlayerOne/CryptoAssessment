//
//  ChartPoint.swift
//  CryptoAssessment
//
//  Created by ikorobov on 14.1.25..
//

import Foundation

struct ChartPoint: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let price: Double
}
