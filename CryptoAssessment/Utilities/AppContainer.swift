//
//  AppContainer.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//
import Foundation

final class AppContainer: ObservableObject {

    private let appCoordinator = AppCoordinator()
    private let userDefaultsManager = UserDefaultsManagerImpl()
    private let networkService = NetworkServiceImpl()
    
    func makeAppCoordinator() -> AppCoordinator {
        appCoordinator
    }
    
    func makeUserDefaultsManager() -> UserDefaultsManager {
        userDefaultsManager
    }
    
    func makeNetworkService() -> NetworkService {
        networkService
    }
    
}

extension AppContainer: AuthServiceContainer {
    func makeAuthService() -> AuthService {
        AuthServiceImpl()
    }
}

extension AppContainer: AuthStateContainer {
    func makeAuthStateManager() -> AuthStateManager {
        AuthStateManagerImpl(authService: makeAuthService(), userDefaultsManager: makeUserDefaultsManager())
    }
}

extension AppContainer: LoginViewModelContainer {
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authStateManager: makeAuthStateManager(), coordinator: makeAppCoordinator())
    }
}

extension AppContainer: @preconcurrency CoinListViewModelContainer {
    @MainActor func makeCryptoListViewModel() -> CoinListViewModel {
        CoinListViewModel(networkService: makeNetworkService(),
                            authStateManager: makeAuthStateManager(),
                            coordinator: makeAppCoordinator())
    }
}

extension AppContainer: @preconcurrency CoinDetailViewModelContainer {
    @MainActor func makeCryptoDetailViewModel(coin: CoinListItem) -> CoinDetailViewModel {
        CoinDetailViewModel(networkService: makeNetworkService(), coin: coin)
    }
    

}
