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

final class NetworkServiceImpl: NetworkService {
    func request<T>(endpoint: String) async throws -> T where T : Decodable {
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(API.apiKey, forHTTPHeaderField: "x-cg-demo-api-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        return try decodeJSON(T.self, from: data)
    }
    
    private func validateResponse(_ response: URLResponse) throws {
         guard let httpResponse = response as? HTTPURLResponse else {
             throw URLError(.badURL)
         }
         
         switch httpResponse.statusCode {
             case 200..<300:
                 break
             case 429:
                 throw URLError(.timedOut, userInfo: ["message": "Exceeded retry limit"])
             default:
                 throw URLError(.badServerResponse, userInfo: ["statusCode": httpResponse.statusCode])
         }
     }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error decoding JSON: \(jsonString)")
            }
            throw error
        }
    }
 
}
