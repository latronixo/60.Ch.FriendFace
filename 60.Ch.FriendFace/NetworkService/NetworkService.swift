//
//  NetworkService.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let session: URLSession = .shared
    
    func fetchPersons() async throws -> [Person] {
        let urlString = "https://www.hackingwithswift.com/samples/friendface.json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("iOSApp", forHTTPHeaderField: "User-Agent  ")
        
        let (data, response) = try await session.data(from: url)
        print("Получен ответа, размер данных: \(data.count) байт")
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let personsArray = try decoder.decode([Person].self, from: data)
            print("Успешно декодировано \(personsArray.count) персон")
            return personsArray
        } catch {
            print("Ошибка декодирования массива: \(error)")
            
            print("Ошибка декодирования: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Отсутствует ключ: \(key.stringValue), путь: \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа: ожидается \(type), путь: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Значение не найдено: \(type), путь: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context)")
                @unknown default:
                    print("Неизвестная ошибка декодирования")
                }
            }
            throw error
        }
    }
}
