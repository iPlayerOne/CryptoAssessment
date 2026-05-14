//
//  AppCoordinator.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

enum AppPage: Hashable {
    case coinList
    case coinDetails(coin: CoinListItem)
}

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isAuthenticated: Bool = false {
        didSet {
            if isAuthenticated {
                showCoinList()
            } else {
                popToRoot()
            }
        }
    }


    func initialize(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }

    func navigateTo(_ page: AppPage) {
        path.append(page)
    }

    private func showCoinList() {
        path = NavigationPath()
        path.append(AppPage.coinList)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func logout() {
        isAuthenticated = false
    }
}
