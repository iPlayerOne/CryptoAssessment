//
//  AppContainer.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//
import Foundation

final class AppContainer: ObservableObject {
    
    static let shared = AppContainer()
    
    private let appCoordinator = AppCoordinator()
    private let userDefaultsManager = UserDefaultsManagerImpl()
    private let networkService = NetworkServiceImpl()
    private let authServiceImpl: AuthService
    private let authStateManagerImpl: AuthStateManager
    private let coinService: CoinService
    
    private init() {
        self.authServiceImpl = AuthServiceImpl()
        self.authStateManagerImpl = AuthStateManagerImpl(
            authService: authServiceImpl,
            userDefaultsManager: userDefaultsManager
        )
        self.coinService = CoinServiceImpl(networkService: networkService)
    }
    
    var coordinator: AppCoordinator {
        appCoordinator
    }
    
    var userDefaults: UserDefaultsManager {
        userDefaultsManager
    }
    
    var network: NetworkService {
        networkService
    }
    
    var coins: CoinService {
        coinService
    }
    
    var authService: AuthService {
        authServiceImpl
    }
    
    var authStateManager: AuthStateManager {
        authStateManagerImpl
    }
}
