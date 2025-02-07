
import SwiftUI
import Charts

struct ChartView: View {
    @StateObject private var vm: ChartViewModel
    
    init(coinId: String) {
        self._vm = StateObject(wrappedValue: ChartViewModel(coinId: coinId))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            DateRangePickerView(selectedRange: $vm.selectedRange, maxRange: vm.maxRange)
                .padding()
            ZStack {
                content
                if let selected = vm.selectedPoint {
                    TooltipView(position: vm.tooltipPosition, price: selected.price, date: selected.timestamp)
                }
            }
            .frame(height: 250)
            .task {
                await vm.loadChart(for: 30)
                await vm.animateData()
            }
            .task(id: vm.selectedRange) {
                await vm.animateData()
            }
        }
    }
}

extension ChartView {
    @ViewBuilder
    private var content: some View {
        if vm.isLoading {
            ProgressView()
                .frame(height: 200)
    } else if !vm.displayedData.isEmpty {
            Chart {
                ForEach(vm.displayedData, id: \.timestamp) { data in
                    LineMark(
                        x: .value("Time", data.timestamp),
                        y: .value("Price", data.price)
                    )
                    .foregroundStyle(Color("darkGreen", bundle: nil))
                    .lineStyle(StrokeStyle(lineWidth: 3, lineJoin: .bevel))
                    .shadow(color: Color.green.opacity(0.5), radius: 20, y: 5)
                    .offset(x: 10)
                }
                .interpolationMethod(.linear)
                
                if let selected = vm.selectedPoint {
                    PointMark(
                        x: .value("Time", selected.timestamp),
                        y: .value("Price", selected.price)
                    )
                    .offset(x: 10)
                    .symbolSize(20)
                    .foregroundStyle(Color.black)
                }
            }
            .offset(x: -10)
            .chartXScale(domain: vm.calculateXScale())
            .chartYScale(domain: vm.calculateYScale())
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(DragGesture()
                            .onChanged { value in
                                vm.updateSelectedPoint(at: value.location, in: proxy, chartBounds: geometry.frame(in: .local))
                            }
                            .onEnded { _ in
                                vm.clearSelection()
                            }
                        )
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
    
    let mockData = MockData()
    
    ChartView(coinId: mockData.coin.id)
}

