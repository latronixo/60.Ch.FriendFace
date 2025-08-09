//
//  PersonViewModel.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class PersonViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func loadPersons(modelContext: ModelContext) async {
        self.isLoading = true
        self.errorMessage = nil
        
        //Если это первый запуск, то загружаем персон из сети
        if !UserDefaults.standard.bool(forKey: "isNotFirstLaunch") {
            //при этом сохраняем в UserDefaults, что первый запуск уже был
            UserDefaults.standard.set(true, forKey: "isNotFirstLaunch")
            
            do {
                print("Начинаем загрузку из сети...")
                let personsAPI = try await NetworkService.shared.fetchPersons()
                print("Получено \(personsAPI.count) персон")
                
                if !personsAPI.isEmpty {
                    let personsToInsert = personsAPI.map { Person(from: $0) }
                    for person in personsToInsert {
                        modelContext.insert(person)
                    }
                    self.isLoading = false
                }
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error to load data from API: \(error.localizedDescription)")
            }
        } else {
            //если это не первый запуск, просто выключаем индикатор загрузки
            self.isLoading = false
        }
    }
}
