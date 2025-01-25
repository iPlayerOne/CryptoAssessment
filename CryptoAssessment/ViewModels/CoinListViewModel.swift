//
//  CryptoListViewModel.swift
//  CryptoAssessment
//
//  Created by ikorobov on 26.12.24..
//

import SwiftUI
import Combine


protocol CoinListViewModelContainer {
    func makeCryptoListViewModel() -> CoinListViewModel
}

@MainActor
final class CoinListViewModel: ObservableObject {

    
    @Published var state: State = .loading
    @Published var sortedBy: SortingOption = .nameAscending
    @Published var searchQuery: String = ""
    @Published private(set) var filteredCoins: [CoinListItem] = []
    
    private var allCoins: [CoinListItem] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private let networkService: NetworkService
    private let authStateManager: AuthStateManager
    private var coordinator: AppCoordinator
    
    init(networkService: NetworkService, authStateManager: AuthStateManager, coordinator: AppCoordinator) {
        self.networkService = networkService
        self.authStateManager = authStateManager
        self.coordinator = coordinator
        
        setupBindings()
    }
    
    
    func fetchCoins(forceRefresh: Bool = false) async {
        state = .loading
        do {
            let coins = try await networkService.fetchCoins(retryCount: 3, forceRefresh: forceRefresh)
            self.allCoins = coins
            self.state = .loaded(self.sortCoins(coins, by: self.sortedBy))
        } catch is CancellationError {
            print("Task was cancelled")
        } catch {
            state = .failed("Cant fetch coins: \(error.localizedDescription)")
        }
    }
    
    func sortCoins(_ coins:[CoinListItem], by option: SortingOption) -> [CoinListItem] {
        switch option {
            case .nameAscending:
                return coins.sorted { $0.name < $1.name }
            case .nameDescending:
                return coins.sorted { $0.name > $1.name }
            case .priceAscending:
                return coins.sorted { ($0.priceUSD ?? 0.0) < ($1.priceUSD ?? 0.0) }
            case .priceDescending:
                return coins.sorted { ($0.priceUSD ?? 0.0) > ($1.priceUSD ?? 0.0) }
            case .change24hAscending:
                return coins.sorted { ($0.percentChange24h ?? 0.0) < ($1.percentChange24h ?? 0.0) }
            case .change24hDescending:
                return coins.sorted { ($0.percentChange24h ?? 0.0) > ($1.percentChange24h ?? 0.0) }
        }
    }
    
    func changeSortingOption(to option: SortingOption) {
        sortedBy = option
        applyFilters()
    }
    
    func selectCoin(_ coin: CoinListItem) {
        coordinator.navigateTo(.coinDetails(coin: coin))
    }
    
    func logout() {
        authStateManager.logout()
        coordinator.logout()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest($searchQuery, $sortedBy)
            .map { [weak self] searchQuery, sortOption -> [CoinListItem] in
                guard let self = self else { return [] }
                var filtered = self.allCoins
                
                if !searchQuery.isEmpty {
                    filtered = filtered.filter {
                        $0.name.localizedCaseInsensitiveContains(searchQuery)
                    }
                }
                let sorted = self.sortCoins(filtered, by: sortOption)
                return sorted
            }
            .sink { [weak self] coins in
                self?.filteredCoins = coins
                self?.state = .loaded(coins)
            }
            .store(in: &cancellables)
    }
    
    private func applyFilters() {
        guard !allCoins.isEmpty else {
            filteredCoins = []
            state = .loaded([])
            return
        }
        let filtered = searchQuery.isEmpty ? allCoins : allCoins.filter {
             $0.name.localizedCaseInsensitiveContains(searchQuery)
         }
        let sorted = sortCoins(filtered, by: sortedBy)
        state = .loaded(sorted)
    }
}

extension CoinListViewModel {
    enum State {
        case loading
        case loaded([CoinListItem])
        case failed(String)
    }
    enum SortingOption {
        case nameAscending
        case nameDescending
        case priceAscending
        case priceDescending
        case change24hAscending
        case change24hDescending
    }
}
