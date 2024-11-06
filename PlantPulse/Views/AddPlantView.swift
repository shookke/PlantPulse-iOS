//
//  AddPlantView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct AddPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: DevicesViewModel
    var onPlantAdded: (Plant) -> Void
    
    @State private var showPlantTypeSelection = false
    @State var selectedPlantType: PlantType?
    @State var plantName = ""
    
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

                if let errorMessage = viewModel.errorMessage {
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
                        viewModel.plantName = plantName
                        viewModel.selectedPlantType = selectedPlantType
                        Task {
                            await viewModel.createPlant()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(plantName.isEmpty || selectedPlantType == nil || viewModel.isCreatingPlant)
                }
            }
            .sheet(isPresented: $showPlantTypeSelection) {
                PlantTypeSelectionView(selectedPlantType: $selectedPlantType)
            }
            .disabled(viewModel.isCreatingPlant)
        }
    }
    
    
}
