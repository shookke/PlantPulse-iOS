//
//  Secrets.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/1/24.
//

import Foundation

struct Secrets {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let key = plist["API_KEY"] as? String else {
            fatalError("Couldn't find API_KEY in Secrets.plist.")
        }
        return key
    }
}
