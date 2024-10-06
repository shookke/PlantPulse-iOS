//
//  AddPlantView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct AddPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    var onPlantAdded: (Plant) -> Void

    @State private var plantName = ""
    @State private var datePlanted: String?
    @State private var dateHarvested: String?
    @State private var lastFertilization: String?
    @State private var selectedPlantType: PlantType?
    @State private var showPlantTypeSelection = false
    @State private var errorMessage: String?
    @State private var isCreatingPlant = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Plant Details")) {
                    TextField("Plant Name", text: $plantName)
                        .autocapitalization(.words)

                    Button(action: {
                        showPlantTypeSelection = true
                    }) {
                        HStack {
                            Text("Plant Type")
                            Spacer()
                            if let plantType = selectedPlantType {
                                Text(plantType.commonName)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Select")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // TODO: Additional Fields (optional)
                // ...

                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Plant")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await createPlant()
                        }
                    }
                    .disabled(plantName.isEmpty || selectedPlantType == nil)
                }
            }
            .sheet(isPresented: $showPlantTypeSelection) {
                PlantTypeSelectionView(selectedPlantType: $selectedPlantType)
            }
            .disabled(isCreatingPlant)
        }
    }
    
    @MainActor
    private func createPlant() async {
        guard let plantType = selectedPlantType else { return }
        isCreatingPlant = true
        errorMessage = nil
        do {
            // Prepare the request
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/") else {
                throw APIError.invalidURL
            }
            
            let newPlantData: [String: Any] = [
                "plant": [
                    "plantType": plantType.id,
                    "container": nil,
                    "area": nil,
                    "plantName": plantName,
                    "datePlanted": datePlanted,
                    "dateHarvested": dateHarvested,
                    "lastFertilization": lastFertilization
                ]
            ]
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: newPlantData)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw APIError.serverError }
            
            
        } catch (let error) {
            errorMessage = error.localizedDescription
        }
    }
}
