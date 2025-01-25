//
//  AuthStateManager.swift
//  CryptoAssessment
//
//  Created by ikorobov on 25.12.24..
//

import Foundation
import Combine

protocol AuthStateManager {
    var isAuthenticated: Bool { get set }
    func login(username: String, password: String) -> Bool
    func logout()
}

protocol AuthStateContainer {
    func makeAuthStateManager() -> AuthStateManager
}

final class AuthStateManagerImpl: ObservableObject, AuthStateManager {
    @Published var isAuthenticated: Bool {
        didSet {
            print("Saving isAuthenticated: \(isAuthenticated)")
            userDefaultsManager.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    private let authService: AuthService
    private let userDefaultsManager: UserDefaultsManager
    
    init(authService: AuthService, userDefaultsManager: UserDefaultsManager) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
        self.isAuthenticated = userDefaultsManager.get(forKey: "isAuthenticated", type: Bool.self) ?? false
        print("Loaded isAuthenticated: \(self.isAuthenticated)")
    }
    
    func login(username: String, password: String) -> Bool {
        isAuthenticated = authService.validate(username: username, password: password)
        return isAuthenticated
    }
    
    func logout() {
        isAuthenticated = false
    }
    
    deinit {
        print("AuthStateManagerImpl deinitialized")
    }
}
