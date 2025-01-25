//
//  CoinChartView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import Foundation
import SwiftUI
import Charts

struct ChartView: View {
    @State private var displayedData: [ChartPoint] = []
    @State private var selectedPoint: ChartPoint? = nil
    @State private var tooltipPosition: CGPoint = .zero
    @State private var chartBounds: CGRect = .zero
    @State private var isAnimating: Bool = false
    
    @Binding var selectedRange: DateInterval
    
    let chartData: [ChartPoint]
    let maxRange: DateInterval
    
    
    var body: some View {
        VStack(spacing: 16) {
            DateRangePickerView(selectedRange: $selectedRange, maxRange: maxRange)
                .padding()
            ZStack {
                content
                if let selected = selectedPoint {
                    TooltipView(position: tooltipPosition, price: selected.price, date: selected.timestamp)
                }
            }
            .frame(height: 250)
            .task(id: selectedRange) {
                await animateData()
            }
        }
    }
    
    private func calculateXScale() -> ClosedRange<Date> {
        guard let firstDate = chartData.first?.timestamp,
              let lastDate = chartData.last?.timestamp,
              firstDate <= lastDate else {
            print("Invalid X scale: defaulting to today's date")
            return Date()...Date()
        }
        
        return firstDate...lastDate
    }
    
    private func calculateYScale() -> ClosedRange<Double> {
        let prices = chartData.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return 0...1
        }
        
        let padding = (maxPrice - minPrice) * 0.1
        return (minPrice - padding)...(maxPrice + padding)
    }
    
    private func updateSelectedPoint(at point: CGPoint, in proxy: ChartProxy) {
        if let date: Date = proxy.value(atX: point.x),
           let closest = displayedData.min(by: { abs($0.timestamp.timeIntervalSince(date)) < abs($1.timestamp.timeIntervalSince(date)) }) {
            selectedPoint = closest
            if let x = proxy.position(forX: closest.timestamp),
               let y = proxy.position(forY: closest.price) {
                tooltipPosition = adjustTooltipPosition(position: CGPoint(x: x, y: y + 60), within: chartBounds, padding: 20)
            }
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
    
    @MainActor
    private func animateData() async {
        guard !isAnimating else { return }
        isAnimating = true
        
        let filteredData = getFilteredData()
        guard filteredData.count > 1 else {
            displayedData = filteredData
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
    
    private func getFilteredData() -> [ChartPoint] {
        chartData.filter { $0.timestamp >= selectedRange.start && $0.timestamp <= selectedRange.end }
    }
    
}

extension ChartView {
    @ViewBuilder
    private var content: some View {
        if !displayedData.isEmpty {
            Chart {
                ForEach(displayedData, id: \.timestamp) { data in
                    LineMark(
                        x: .value("Time", data.timestamp),
                        y: .value("Price", data.price)
                    )
                    .foregroundStyle(Color.green)
                    .lineStyle(StrokeStyle(lineWidth: 3, lineJoin: .bevel))
                    .shadow(color: Color.green.opacity(0.7), radius: 10, y: 5)
                    .offset(x: 10)
                }
                .interpolationMethod(.catmullRom)
                
                if let selected = selectedPoint {
                    PointMark(
                        x: .value("Time", selected.timestamp),
                        y: .value("Price", selected.price)
                    )
                    .offset(x: 10)
                    .symbolSize(20)
                    .foregroundStyle(Color.black)
                }
            }
//            .offset(x: 10)
            .chartXScale(domain: calculateXScale())
            .chartYScale(domain: calculateYScale())
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(DragGesture()
                            .onChanged { value in
                                updateSelectedPoint(at: value.location, in: proxy)
                            }
                            .onEnded { _ in
                                selectedPoint = nil
                            }
                        )
                        .onAppear {
                            chartBounds = geometry.frame(in: .local)
                        }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    if let price = value.as(Double.self) {
                        AxisValueLabel {
                            Text(price.formattedAsCurrency())
                                .foregroundStyle(.secondary)
                        }
                        AxisGridLine()
                            .foregroundStyle(Color.gray.opacity(0.3))
                    }
                }
            }
            
        } else {
            Text("No chart data available")
                .foregroundColor(.secondary)
                .frame(height: 200)
        }
    }
}

#Preview {
    @Previewable @State var selectedRange: DateInterval = {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
        return DateInterval(start: start, end: end)
    }()
    
    let mockData = MockData()
    
    ChartView(
        selectedRange: $selectedRange,
        chartData: mockData.chartData,
        maxRange: DateInterval(start: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(), end: Date())
    )
}

