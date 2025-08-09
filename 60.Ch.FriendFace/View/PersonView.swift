//
//  PersonView.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import SwiftUI
import SwiftData

struct PersonView: View {
    @StateObject var viewModel = PersonViewModel()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Person.name) private var persons: [Person]
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Ошибка загрузки")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red   )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if persons.isEmpty {
                    Text("нет данных")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(persons) { person in
                        NavigationLink(destination: PersonDetailView(person: person)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(person.name)
                                        .font(.headline)
                                    Text(person.company)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(person.age) лет")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(person.isActive ? "Активен" : "Неактивен")
                                        .font(.caption)
                                        .foregroundColor(person.isActive ? .green : .red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Persons")
        }
        .task {
            //Загружаем данные, только если база данных пуста
            if persons.isEmpty {
                //передаем потокобезопасный ModelContainer во ViewModel
                await viewModel.loadPersons(container: modelContext.container)
            }
        }
    }
}

#Preview("С данными") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Person.self, configurations: config)
        
        let samplePerson = Person(id: "1", isActive: true, name: "John Doe", age: 30, company: "Apple", address: "123 Main St", about: "Dev", registered: .now, tags: ["swift"], friends: [])
                container.mainContext.insert(samplePerson)
                
        return PersonView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
