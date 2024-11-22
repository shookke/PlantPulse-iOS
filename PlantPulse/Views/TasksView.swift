//
//  TasksView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    
    @State private var viewCompleted = false

    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Button(action: {
                    viewCompleted.toggle()
                }) {
                    HStack {
                        if (viewCompleted == false) {
                            Text("View Completed Tasks")
                                .font(.footnote)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        } else {
                            Text("View Completed Tasks")
                                .font(.footnote)
                                .bold()
                            Image(systemName: "chevron.up")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                }
            }
            List {
                ForEach(viewModel.todos) { todo in
                    if (todo.status != "completed" || viewCompleted == true) {
                        NavigationLink(destination: TaskDetailView(todo: todo, viewModel: viewModel)) {
                            HStack {
                                AnimatedIcon(metric: todo.metric)
                                    .frame(width: 40, height: 40)
                                VStack(alignment: .leading) {
                                    Text(todo.message)
                                        .font(.headline)
                                    Text("Status: \(todo.status)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .onAppear {
                viewModel.loadData()
            }
            .refreshable {
                viewModel.loadData()
            }
        }
        
    }
}

#Preview {
    TasksView()
}
