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
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            print("Начинаем загрузку данных...")
            let personsAPI = try await NetworkService.shared.fetchPersons()
            print("Получено \(personsAPI.count) персон")
                        
            if !personsAPI.isEmpty {
                await MainActor.run {
                    self.persons = personsAPI
                    self.isLoading = false
                }
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("Error to load data from API: \(error.localizedDescription)")
        }
    }
}
