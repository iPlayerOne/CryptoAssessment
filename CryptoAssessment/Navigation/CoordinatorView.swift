//
//  CoordinatorView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    private let container: AppContainer
    
    init(container: AppContainer) {
        print("CoordinatorView rendered")
        self.container = container
    }
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            LoginView(container: container)
                .navigationDestination(for: AppPage.self) { page in
                    switch page {
                        case .login:
                            LoginView(container: container)
                        case .coinList:
                            CoinsListView(container: container)
                        case .coinDetails(coin: let coin):
                            CoinDetailView(container: container, coin: coin)
                                
                    }
                }
        }
    }
}

#Preview {
    let container = AppContainer()
    let appCoordinator = AppCoordinator()
    CoordinatorView(container: container)
        .environmentObject(appCoordinator)

}
