import Foundation

protocol UserDefaultsManager {
    func set<T>(_ value: T, forKey key: String) where T: Codable
    func get<T>(forKey key: String, type: T.Type) -> T? where T: Codable
    func remove(forKey key: String)
}

final class UserDefaultsManagerImpl: UserDefaultsManager {
    private let defaults = UserDefaults.standard
    
    
    
    func set<T>(_ value: T, forKey key: String) where T : Decodable, T : Encodable {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func get<T>(forKey key: String, type: T.Type) -> T? where T : Decodable, T : Encodable {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    
}
