//
//  CoordinatorView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
   
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            LoginView()
                .navigationDestination(for: AppPage.self) { page in
                    switch page {
                        case .login:
                            LoginView()
                        case .coinList:
                            CoinsListView()
                        case .coinDetails(coin: let coin):
                            CoinDetailView(coin: coin)
                                
                    }
                }
        }
    }
}

#Preview {
    let appCoordinator = AppCoordinator()
    CoordinatorView()
 
        .environmentObject(appCoordinator)

}
