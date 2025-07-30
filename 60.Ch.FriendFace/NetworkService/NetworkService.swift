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
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(PersonResponse.self, from: data)
        return decodedResponse.results
    }
}
