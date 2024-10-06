//
//  AddArea.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import Foundation

struct AddArea: Codable {
    let name: String
    let areaType: String
    let description: String
}

enum AreaType: String, Codable, CaseIterable, Hashable {
    case indoor
    case outdoor

    var displayName: String {
        switch self {
        case .indoor:
            return "Indoor"
        case .outdoor:
            return "Outdoor"
        }
    }
}
