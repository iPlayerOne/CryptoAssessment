//
//  LoginViewModel.swift
//  CryptoAssessment
//
//  Created by ikorobov on 26.12.24..
//


import SwiftUI


final class LoginViewModel: ObservableObject {
    @Published var username: String = "" {
        didSet {
            clearError()
        }
    }
    @Published var password: String = "" {
        didSet {
            clearError()
        }
    }
    @Published var errorMessage: String? = nil
    
    private let authStateManager: AuthStateManager
    private let coordinator: AppCoordinator
    
    init(
        authStateManager: AuthStateManager = AppContainer.shared.authStateManager,
        coordinator: AppCoordinator = AppContainer.shared.coordinator
    ) {
        self.authStateManager = authStateManager
        self.coordinator = coordinator
    }
    
    func login() {
        errorMessage = nil
        
        if username.isEmpty {
            errorMessage = "Username cannot be empty"
        }
        if password.isEmpty {
            errorMessage = "Password cannot be empty"
        }
        if authStateManager.login(username: username, password: password) {
            coordinator.navigateTo(.coinList)
        } else {
            errorMessage = "Invalid username or password"
        }
    }
    
    func resetState() {
           username = ""
           password = ""
       }
    
    private func clearError() {
        if errorMessage != nil {
            errorMessage = nil
        }
    }
    
   
}
