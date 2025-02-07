protocol CoinService {
    func fetchCoins(retryCount: Int, forceRefresh: Bool) async throws -> [CoinListItem]
    func fetchCoinDetails(with coinId: String) async throws -> CoinDetails
    func fetchMarketChart(with coinId: String, days: Int) async throws -> [[Double]]
}