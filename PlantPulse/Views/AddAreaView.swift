//
//  AddAreaView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct AddAreaView: View {
    @Environment(\.presentationMode) var presentationMode
    var onAreaAdded: (Area) -> Void
    @StateObject private var addAreaViewModel: AddAreaViewModel

    // Custom initializer to pass the closure to the ViewModel
    init(onAreaAdded: @escaping (Area) -> Void) {
        self.onAreaAdded = onAreaAdded
        _addAreaViewModel = StateObject(wrappedValue: AddAreaViewModel(onAreaAdded: onAreaAdded))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Area Details")) {
                    // Area Type Picker
                    Picker("Area Type", selection: $addAreaViewModel.selectedAreaType) {
                        ForEach(AreaType.allCases, id: \.self) { areaType in
                            Text(areaType.displayName).tag(areaType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Area Name TextField
                    TextField("Area Name", text: $addAreaViewModel.areaName)
                        .autocapitalization(.words)
                    
                    // Area Description TextField
                    TextField("Area Description", text: $addAreaViewModel.areaDescription)
                }

                // Display error message if any
                if let errorMessage = addAreaViewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Area")
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                           try await addAreaViewModel.createArea()
                        }
                    }
                    .disabled(addAreaViewModel.areaName.isEmpty)
                }
            }
        }
        .disabled(addAreaViewModel.isCreatingArea) // Disable the form while creating
    }
}
