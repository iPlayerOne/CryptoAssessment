//
//   Double+Extensions.swift
//  CryptoAssessment
//
//  Created by ikorobov on 12.1.25..
//

import Foundation

extension Double {
    func formattedAsCurrency() -> String {
        if self >= 1_000_000_000 {
            return "\(String(format: "%.2f", self / 1_000_000_000))B"
        } else if self >= 1_000_000 {
            return "\(String(format: "%.2f", self / 1_000_000))M"
        } else if self >= 1_000 {
            return "\(String(format: "%.2f", self / 1_000))K"
        } else {
            return "\(String(format: "%.2f", self))$"
        }
    }
}
