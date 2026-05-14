//
//  NetworkManager.swift
//  CryptoAssessment
//
//  Created by ikorobov on 27.12.24..
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endpoint: String) async throws -> T
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case rateLimitReached
    case serverError(statusCode: Int, message: String?)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Invalid request URL."
            case .invalidResponse:
                return "Invalid server response."
            case .rateLimitReached:
                return "CoinGecko rate limit reached. Please try again later."
            case .serverError(let statusCode, let message):
                if let message, !message.isEmpty {
                    return "Server error \(statusCode): \(message)"
                }
                return "Server error \(statusCode)."
            case .decodingFailed:
                return "Failed to read server response."
        }
    }
}

final class NetworkServiceImpl: NetworkService {
    func request<T>(endpoint: String) async throws -> T where T : Decodable {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        if let apiKey = API.apiKey, !apiKey.isEmpty {
            request.addValue(apiKey, forHTTPHeaderField: "x-cg-demo-api-key")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)
        
        return try decodeJSON(T.self, from: data)
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
         guard let httpResponse = response as? HTTPURLResponse else {
             throw NetworkError.invalidResponse
         }
         
         switch httpResponse.statusCode {
             case 200..<300:
                 break
             case 429:
                 throw NetworkError.rateLimitReached
             default:
                 let message = String(data: data, encoding: .utf8)
                 print("Request failed with status \(httpResponse.statusCode): \(message ?? "No response body")")
                 throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
         }
     }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error decoding JSON: \(jsonString)")
            }
            throw NetworkError.decodingFailed(error)
        }
    }
 
}
