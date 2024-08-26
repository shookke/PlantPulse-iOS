//
//  KeychainHelper.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import Foundation
import Security

enum KeychainError: Error {
    case invalidData
    case unhandledError(status: OSStatus)
}

class KeychainHelper {
    static let shared = KeychainHelper()
    
    // Key to store the token in Keychain
    private let tokenKey = "authToken"
    private let expirationKey = "authTokenExpiration"
    
    func saveAuthToken(_ token: String, expiration: Date) {
        let encoder = JSONEncoder()
        // Convert expiration date to data
        guard let expirationData = try? encoder.encode(expiration) else {
            print("Failed to encode expiration date")
            return
        }
        
        // Save the token
        save(tokenKey, data: Data(token.utf8))
        
        // Save the expiration date
        save(expirationKey, data: expirationData)
    }
           
    func getAuthToken() -> String? {
        if let tokenData = load(tokenKey) {
            return String(data: tokenData, encoding: .utf8)
        }
        return nil
    }
    
    func getExpirationDate() -> Date? {
        if let expirationDate = load(expirationKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(Date.self, from: expirationDate)
        }
        return nil
    }
    
    func deleteAuthToken() {
        delete(tokenKey)
        delete(expirationKey)
    }
}

private func save(_ key: String, data: Data) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: data
    ]
    
    // Delete any existing item
    SecItemDelete(query as CFDictionary)
    
    // Add the new token
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status != errSecSuccess {
        print("Error saving token to Keychain: \(status)")
    }
}

private func load(_ key: String) -> Data? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess {
        return result as? Data
    } else {
        print("Error retrieving token from keychain: \(status)")
        return nil
    }
}

private func delete(_ key: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    if status != errSecSuccess {
        print("Error deleting token from Keychain: \(status)")
    }
}
