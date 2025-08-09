//
//  PersonViewModel.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import Foundation
import SwiftData
import SwiftUI

final class PersonViewModel: ObservableObject {
    @Environment(\.modelContext) var modelContext
    @Query var persons: [Person] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func loadPersons() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        //Если это первый запуск, то загружаем персон из сети
        if !UserDefaults.standard.bool(forKey: "isNotFirstLaunch") {
            //при этом сохраняем в UserDefaults, что первый запуск уже был
            UserDefaults.standard.set(true, forKey: "isNotFirstLaunch")
            
            do {
                print("Начинаем загрузку данных...")
                let personsAPI = try await NetworkService.shared.fetchPersons()
                print("Получено \(personsAPI.count) персон")
                
                if !personsAPI.isEmpty {
                    await MainActor.run {
                        for personAPI in personsAPI {
                            modelContext.insert(Person(from: personAPI))
                        }
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
        } else {
            //если же это не первый запуск, то загружаем персон из SwiftData
            
            
        }
    }
}
