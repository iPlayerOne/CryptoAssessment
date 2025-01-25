//
//  AuthService.swift
//  CryptoAssessment
//
//  Created by ikorobov on 26.12.24..
//

protocol AuthService {
    func validate(username: String, password: String) -> Bool
}

protocol AuthServiceContainer {
    func makeAuthService() -> AuthService
}

final class AuthServiceImpl: AuthService {
    func validate(username: String, password: String) -> Bool {
        username == "qwerty" && password == "qwerty"
    }
}
