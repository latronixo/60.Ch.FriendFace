//
//  PersonView.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import SwiftUI

struct PersonView: View {
    @EnvironmentObject var viewModel: PersonViewModel
    
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
                } else if viewModel.persons.isEmpty {
                    Text("нет данных")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.persons) { person in
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
        .onAppear {
            Task {
                await viewModel.loadPersons()
            }
        }
    }
}

#Preview("Загрузка") {
    PersonView()
        .environmentObject({
            let vm = PersonViewModel()
            vm.isLoading = true
            return vm
        }())
}

#Preview("С данными") {
    PersonView()
        .environmentObject({
            let vm = PersonViewModel()
            vm.persons = [
                PersonAPI(
                    id: "1",
                    isActive: true,
                    name: "John Doe",
                    age: 30,
                    company: "Apple",
                    address: "123 Main St",
                    about: "Software developer",
                    registered: Date(),
                    tags: ["iOS", "Swift"],
                    friends: []
                ),
                PersonAPI(
                    id: "2",
                    isActive: false,
                    name: "Jane Smith",
                    age: 25,
                    company: "Google",
                    address: "456 Oak Ave",
                    about: "Designer",
                    registered: Date(),
                    tags: ["UI", "UX"],
                    friends: []
                )
            ]
            return vm
        }())
}

#Preview("С ошибкой") {
    PersonView()
        .environmentObject({
            let vm = PersonViewModel()
            vm.errorMessage = "Ошибка сети"
            return vm
        }())
}
