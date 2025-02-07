import SwiftUI

final class CoinDetailViewModel: ObservableObject {
    @Published var coinDetails: CoinDetails?
    @Published var attributedDescription: AttributedString?
    @Published var errorMessage: String?

    
    private let coinId: String
    private let coinService: CoinService
   
    
    init(coinId: String,
         coinService: CoinService = AppContainer.shared.coins
    ) {
        self.coinId = coinId
        self.coinService = coinService
        
    }
    
    @MainActor
    func loadDetails() async {
        do {
            let details = try await coinService.fetchCoinDetails(with: coinId)
                self.coinDetails = details
                self.attributedDescription = self.parseHTML(details.description?.en)
        } catch {
                self.errorMessage = "Failed to fetch coin details: \(error.localizedDescription)"
        }
    }
    
    func resetData() {
        self.coinDetails = nil
        self.errorMessage = nil
    }
    
    private func parseHTML(_ html: String?) -> AttributedString? {
        guard let html = html else { return nil }
        return AttributedString(html: html)
    }
}

