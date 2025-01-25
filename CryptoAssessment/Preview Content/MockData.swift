import Foundation

struct MockData {
    let coin = CoinListItem(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "BTC",
        imageUrl: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        priceUSD: 27345.67,
        percentChange24h: 2.56,
        volume: 10,
        marketCap: 523457890123.45,
        rank: 1
    )
    
    let coinDetail = CoinDetails(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "BTC",
        description: CoinDetails.Description(en: "Bitcoin is the first cryptocurrency."),
        links: CoinDetails.Links(
            homepage: ["https://bitcoin.org"],
            twitterScreenName: "bitcoin",
            facebookUsername: "bitcoins"
        )
    )
    
    let chartData: [ChartPoint] = [
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date(), price: 27345.67),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), price: 27500.00),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), price: 27100.00),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), price: 26800.00),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), price: 26500.00),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), price: 27000.00),
        ChartPoint(timestamp: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), price: 27300.00)
    ]
}
