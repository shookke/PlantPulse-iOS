//
//  AddAreaViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/29/24.
//

import Foundation

class AddAreaViewModel: ObservableObject {
    // Published properties to bind with the view
    @Published var areaName: String = ""
    @Published var selectedAreaType: AreaType = .indoor
    @Published var areaDescription: String = ""
    @Published var errorMessage: String?
    @Published var isCreatingArea: Bool = false

    // Closure to notify the parent view upon successful area creation
    var onAreaAdded: (Area) -> Void

    // Initialization with the closure
    init(onAreaAdded: @escaping (Area) -> Void) {
        self.onAreaAdded = onAreaAdded
    }

    // Function to create a new area
    @MainActor
    func createArea() async throws {
        guard !areaName.isEmpty else {
            errorMessage = "Area name cannot be empty."
            return
        }

        isCreatingArea = true
        errorMessage = nil
        do {
            // Prepare the request
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/areas") else {
                isCreatingArea = false
                errorMessage = "Invalid URL."
                return
            }
            
            // Create the AddArea data
            let newAreaData: [String: Any] = [
                "name": areaName,
                "areaType": selectedAreaType.rawValue,
                "description": areaDescription
            ]

            let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: newAreaData)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate the response
            guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw APIError.serverError }

            let createdArea = try JSONDecoder().decode(Area.self, from: data)
            
            self.onAreaAdded(createdArea)
            
        } catch {
            self.errorMessage = "Failed to decode response."
        }
    }
}

