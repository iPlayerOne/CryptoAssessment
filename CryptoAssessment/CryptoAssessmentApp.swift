//
//  CryptoAssessmentApp.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import SwiftUI

@main
struct CryptoAssessmentApp: App {
    @StateObject private var appCoordinator: AppCoordinator

        init() {
            let container = AppContainer.shared
            let authStateManager = container.authStateManager
            let coordinator = container.coordinator
            coordinator.initialize(isAuthenticated: authStateManager.isAuthenticated)
            
            _appCoordinator = StateObject(wrappedValue: coordinator)
        }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(appCoordinator)
                
        }
    }
}
