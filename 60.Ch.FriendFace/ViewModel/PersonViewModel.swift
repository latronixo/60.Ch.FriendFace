//
//  PersonViewModel.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import Foundation

final class PersonViewModel: ObservableObject {
    @Published var persons: [Person] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func loadPersons() async {
        await MainActor.run { self.isLoading = true }
        await MainActor.run { self.errorMessage = nil }
        
        do {
            let personsAPI = try await NetworkService.shared.fetchPersons()
            if !personsAPI.isEmpty {
                await MainActor.run {
                    self.persons = personsAPI
                }
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("Error to load data from API: \(error.localizedDescription)")
        }
    }
}
