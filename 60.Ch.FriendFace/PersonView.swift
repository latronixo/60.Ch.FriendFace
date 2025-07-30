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
                        HStack {
                            Text("\(person.name)")
                            Spacer()
                            Text("\(person.isActive)")
                        }
                        .padding()
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

#Preview("С данными") {
    PersonView()
        .environmentObject({
            let vm = PersonViewModel()
            vm.persons = [
                Person(
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
                Person(
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
