//
//  CryptoAssessmentApp.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

@main
struct CryptoAssessmentApp: App {
    private let container = AppContainer()
    private let appCoordinator: AppCoordinator

        init() {
            let authStateManager = container.makeAuthStateManager()
            self.appCoordinator = container.makeAppCoordinator()
            self.appCoordinator.initialize(isAuthenticated: authStateManager.isAuthenticated)
        }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(container: container)
                .environmentObject(appCoordinator)
        }
    }
}
