//
//   ChartViewModel.swift
//  CryptoAssessment
//
//  Created by ikorobov on 3.2.25..
//

import SwiftUI
import Charts

@MainActor
final class ChartViewModel: ObservableObject {
    @Published var displayedData: [ChartPoint] = []
    @Published var selectedPoint: ChartPoint? = nil
    @Published var tooltipPosition: CGPoint = .zero
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
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
    
    private let coinId: String
    private let coinService: CoinService
    private var chartData: [ChartPoint] = []
    private var isAnimating = false


    init(coinId: String, coinService: CoinService = AppContainer.shared.coins) {
        self.coinId = coinId
        self.coinService = coinService
    }
    
    func loadChart(for days: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let rawData = try await coinService.fetchMarketChart(with: coinId, days: days)
            let transformedData = transformToChartPoint(rawData)
            
            self.chartData = transformedData
                if let firstDate = transformedData.first?.timestamp,
                   let lastDate = transformedData.last?.timestamp {
                    print("loadChart() Chart data from \(firstDate) to \(lastDate)")
                } else {
                    print("No chart data available")
                }
        } catch {
                self.errorMessage = "Failed to fetch chart data: \(error.localizedDescription)"
        }
    }
    
    func animateData() async {
        guard !isAnimating else { return }
        isAnimating = true
        let filteredData = chartData.filter { $0.timestamp >= selectedRange.start && $0.timestamp <= selectedRange.end }
        guard !filteredData.isEmpty else {
            displayedData = []
            isAnimating = false
            return
        }
        
        displayedData = []
        let totalDuration: UInt64 = 1_000_000_000
        let interval = totalDuration / UInt64(filteredData.count)
        
        for point in filteredData {
            displayedData.append(point)
            try? await Task.sleep(nanoseconds: interval)
        }
        
        isAnimating = false
    }
    
    func updateSelectedPoint(at point: CGPoint, in proxy: ChartProxy, chartBounds: CGRect) {
        if let date: Date = proxy.value(atX: point.x),
           let closest = displayedData.min(by: { abs($0.timestamp.timeIntervalSince(date)) < abs($1.timestamp.timeIntervalSince(date)) }) {
            selectedPoint = closest
            if let x = proxy.position(forX: closest.timestamp),
               let y = proxy.position(forY: closest.price) {
                tooltipPosition = adjustTooltipPosition(position: CGPoint(x: x, y: y + 60), within: chartBounds, padding: 20)
            }
        }
    }
    
    func clearSelection() {
        selectedPoint = nil
    }
    
    func calculateXScale() -> ClosedRange<Date> {
        if selectedRange.start <= selectedRange.end {
            return selectedRange.start ... selectedRange.end
        } else {
            print("Invalid selectedRange, defaulting to today's date")
            return Date()...Date()
        }
    }
    
    func calculateYScale() -> ClosedRange<Double> {
        let prices = chartData.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return 0...1
        }
        
        let padding = (maxPrice - minPrice) * 0.1
        return (minPrice - padding)...(maxPrice + padding)
    }
    
    private func transformToChartPoint(_ data: [[Double]]) -> [ChartPoint] {
        return data.compactMap { array in
            guard array.count == 2 else { return nil }
            let timestamp = Date(timeIntervalSince1970: array[0] / 1000)
            let price = array[1]
            return ChartPoint(timestamp: timestamp, price: price)
        }
    }
    
    private func adjustTooltipPosition(position: CGPoint, within bounds: CGRect, padding: CGFloat) -> CGPoint {
        let tooltipWidht: CGFloat = 150
        var adjustedPosition = position
        adjustedPosition.y = bounds.minY + 10
        if adjustedPosition.x - tooltipWidht / 2 < bounds.minX {
            adjustedPosition.x = bounds.minX + tooltipWidht / 2 - padding
        } else if adjustedPosition.x + tooltipWidht / 2 > bounds.maxX  {
            adjustedPosition.x = bounds.maxX - tooltipWidht / 2 + padding
        }
        
        return adjustedPosition
    }
    
}
