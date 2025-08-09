import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Основная информация
                VStack(alignment: .leading, spacing: 8) {
                    Text(person.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Возраст: \(person.age)")
                        Spacer()
                        Text("Статус: \(person.isActive ? "Активен" : "Неактивен")")
                            .foregroundColor(person.isActive ? .green : .red)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom)
                
                // Компания и адрес
                VStack(alignment: .leading, spacing: 8) {
                    Text("Компания")
                        .font(.headline)
                    Text(person.company)
                        .font(.body)
                    
                    Text("Адрес")
                        .font(.headline)
                    Text(person.address)
                        .font(.body)
                }
                
                // О человеке
                VStack(alignment: .leading, spacing: 8) {
                    Text("О человеке")
                        .font(.headline)
                    Text(person.about)
                        .font(.body)
                }
                
                // Дата регистрации
                VStack(alignment: .leading, spacing: 8) {
                    Text("Дата регистрации")
                        .font(.headline)
                    Text(person.registered, style: .date)
                        .font(.body)
                }
                
                // Теги
                VStack(alignment: .leading, spacing: 8) {
                    Text("Теги")
                        .font(.headline)
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80))
                    ], spacing: 8) {
                        ForEach(person.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Друзья
                VStack(alignment: .leading, spacing: 8) {
                    Text("Друзья (\(person.friends.count))")
                        .font(.headline)
                    
                    if person.friends.isEmpty {
                        Text("Нет друзей")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(person.friends, id: \.id) { friend in
                            Text(friend.name)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        let sampleFriend = Friend(id: "2", name: "Jane Smith")
        let samplePerson = Person(id: "1", isActive: true, name: "Jogn Doe", age: 30, company: "Apple Inc.", address: "Открытое ш. 17 корпус 7", about: "iOS-разработчик", registered: Date(), tags: ["iOS", "Swift", "SwiftUI", "Development"], friends: [sampleFriend])
        PersonDetailView(person: samplePerson)
    }
} 
