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
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func loadPersons(container: ModelContainer) async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        //Если это первый запуск, то загружаем персон из сети
        if !UserDefaults.standard.bool(forKey: "isNotFirstLaunch") {
            //при этом сохраняем в UserDefaults, что первый запуск уже был
            UserDefaults.standard.set(true, forKey: "isNotFirstLaunch")
            
            do {
                print("Начинаем загрузку из сети...")
                let personsAPI = try await NetworkService.shared.fetchPersons()     //в сеть запрос идет в фоне
                print("Получено \(personsAPI.count) персон")
                
                //создаем новый контекст для фоновой работы
                let backgroundContext = ModelContext(container)
                
                if !personsAPI.isEmpty {
                    let personsToInsert = personsAPI.map { Person(from: $0) }
                    for person in personsToInsert {
                        backgroundContext.insert(person)
                    }
                }
                
                //Сохраняем изменения, сделанные в фоновом контексте
                try backgroundContext.save()
                print("данные упешно сохранены в SwiftData")
                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
                print("Error to load data from API: \(error.localizedDescription)")
            }
        }
        
        //Обновляем isLoading на главном потоке в любом случае
        await MainActor.run {
            self.isLoading = false
        }
    }
}
