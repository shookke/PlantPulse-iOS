//
//  UserDefaultsHelper.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/28/24.
//

import Foundation

class UserDefaultsHelper {
    static let userKey = "loggedInUser"
    
    static func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    static func loadUser() -> User? {
        if let savedUserData = UserDefaults.standard.object(forKey: userKey) as? Data {
            if let user = try? JSONDecoder().decode(User.self, from: savedUserData) {
                return user
            }
        }
        return nil
    }
    
    static func removeUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
