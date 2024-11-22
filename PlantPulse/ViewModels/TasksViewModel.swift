//
//  TasksViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/21/24.
//

import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var todos: [ToDoTask] = []
    @Published var todo: ToDoTask? = nil
    @Published var taskError: String? = ""

    init() {
       loadData()
    }
}

extension TasksViewModel {
    @MainActor
    func fetchTasks() async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/tasks") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url,  method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let decoder = JSONDecoder()
            guard let data = try? decoder.decode(TasksResponse.self, from: data) else { throw APIError.noData }

            self.todos = data.todos
            
        } catch {
            self.taskError = error.localizedDescription
        }
    }
    
    @MainActor
    func completeTask(taskId: String) async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/tasks/\(taskId)") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url,  method: "POST", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(TaskCompleteResponse.self, from: data) else { throw APIError.noData }
            
            if let index = self.todos.firstIndex(where: { $0.id == data.todo.id }) {
                self.todos[index] = data.todo
            }
            self.todo = data.todo
            
        } catch {
            self.taskError = error.localizedDescription
        }
    }
    
    func loadData() {
        Task(priority: .userInitiated) {
            await fetchTasks()
        }
    }
}
