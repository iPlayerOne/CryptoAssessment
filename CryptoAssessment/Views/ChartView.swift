
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
            chartArea
        }
    }
}

extension ChartView {
    @ViewBuilder
    private var chartArea: some View {
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

    @ViewBuilder
    private var content: some View {
        if vm.isLoading {
            ProgressView()
                .frame(height: 200)
        } else if let errorMessage = vm.errorMessage {
            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(height: 200)
                .padding(.horizontal)
        } else if !vm.displayedData.isEmpty {
            priceChart
        } else {
            Text("No chart data available")
                .foregroundColor(.secondary)
                .frame(height: 200)
        }
    }

    private var priceChart: some View {
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
            interactiveOverlay(proxy: proxy)
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
    }

    private func interactiveOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            vm.updateSelectedPoint(
                                at: value.location,
                                in: proxy,
                                chartBounds: geometry.frame(in: .local)
                            )
                        }
                        .onEnded { _ in
                            vm.clearSelection()
                        }
                )
        }
    }
}

#Preview {

    let mockData = MockData()

    ChartView(coinId: mockData.coin.id)
}
