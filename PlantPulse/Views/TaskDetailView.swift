//
//  TaskDetailView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/21/24.
//

import SwiftUI

struct TaskDetailView: View {
    let todo: ToDoTask
    @ObservedObject var viewModel: TasksViewModel
    @State private var isCompletingTask = false
    @State private var completionError: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                NavigationLink(destination: PlantInfoView(plant: todo.plant, areas: []), label: {
                    Text(todo.plant.plantName)
                        .font(.title)
                        .padding()
                })
                Spacer()
                AnimatedIcon(metric: todo.metric)
                    .frame(maxWidth: 50, maxHeight: 50)
                    .padding(.horizontal)
                Spacer()
            }
            // Task Message
            Text(todo.message)
                .font(.title2)
                .padding()

            // Complete Task Button
            Button(action: {
                Task {
                    await completeTask()
                }
                dismiss()
            }) {
                Text("Complete Task")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCompletingTask ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(isCompletingTask)

            Spacer()
        }
        .navigationTitle("Task Details")
        .alert(isPresented: Binding<Bool>(
            get: { completionError != nil },
            set: { _ in completionError = nil }
        )) {
            Alert(title: Text("Error"), message: Text(completionError ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func completeTask() async{
        isCompletingTask = true
        Task {
            await viewModel.completeTask(taskId: todo.id)
        }
    }
}
