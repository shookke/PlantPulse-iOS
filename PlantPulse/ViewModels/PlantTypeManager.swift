//
//  PlantTypeManager.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import Foundation
import Combine

@MainActor
class PlantTypeManager: ObservableObject {
    @Published var plantTypes: [PlantType] = []
    @Published var isLoading = false
    @Published var canLoadMore = true
    @Published var searchQuery = ""
    @Published var errorMessage: String? = nil // For error handling

    private var currentPage = 1
    private let limit = 20
    private var cancellables = Set<AnyCancellable>()

    func loadPlantTypes() async {
        // Prevent multiple simultaneous loads and check if more data can be loaded
        guard !isLoading && canLoadMore else { return }
        isLoading = true
        errorMessage = nil

        // Construct the base URL
        guard let baseURL = URL(string: "\(NetworkConstants.baseURL)/plantTypes") else {
            self.isLoading = false
            self.canLoadMore = false
            self.errorMessage = "Invalid base URL."
            return
        }

        // Add query parameters for pagination and search
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "query", value: searchQuery.isEmpty ? nil : searchQuery)
        ].compactMap { $0 } // Remove any nil query items

        guard let requestURL = components.url else {
            self.isLoading = false
            self.canLoadMore = false
            self.errorMessage = "Failed to construct request URL."
            return
        }

        do {
            // Use APIHelper to format the request
            let request = try APIHelper.shared.formatRequest(url: requestURL, method: "GET", body: nil)

            // Perform the network request using URLSession and Swift Concurrency
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check HTTP response status
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknownError
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.serverError
            }

            // Decode the response
            let plantTypesResponse = try JSONDecoder().decode(PlantTypesQueryResponse.self, from: data)

            // Check if the response contains plant types
            guard !plantTypesResponse.types.isEmpty else {
                throw APIError.noData
            }

            // Append new plant types for pagination
            self.plantTypes.append(contentsOf: plantTypesResponse.types)

            // Update `canLoadMore` based on fetched data count
            self.canLoadMore = plantTypesResponse.types.count == self.limit

            // Increment `currentPage` for next fetch
            self.currentPage += 1

        } catch let error as APIError {
            // Handle known API errors
            self.errorMessage = error.localizedDescription
            self.canLoadMore = false
        } catch let decodingError as DecodingError {
            print(decodingError)
            self.errorMessage = APIError.decodingError.localizedDescription
            self.canLoadMore = false
        } catch {
            // Handle any other errors
            self.errorMessage = error.localizedDescription
            self.canLoadMore = false
        }

        // Reset loading state
        self.isLoading = false
    }

    func loadMorePlantTypes() async {
        await loadPlantTypes()
    }

    func resetAndLoadPlantTypes() async {
        currentPage = 1
        plantTypes = []
        canLoadMore = true
        await loadPlantTypes()
    }
}

struct PlantTypesQueryResponse: Codable {
    let types: [PlantType]
}
