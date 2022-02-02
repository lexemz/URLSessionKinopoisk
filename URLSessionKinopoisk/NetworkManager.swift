//
//  NetworkManager.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 02.02.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchFilms(from url: String, completionHandler: @escaping (Result<Films, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            
            completionHandler(Result.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("dfbdb563-ebca-44db-92ae-b6dbbd58219f", forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let _ = response else {
                
                DispatchQueue.main.async {
                    completionHandler(.failure(.noData))
                }
                return
            }
            
            do {
                let filmsInDict = try JSONSerialization.jsonObject(with: data)
                print(filmsInDict)
                
                
                let films = try JSONDecoder().decode(Films.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(.success(films))
                }
            } catch {
                
                DispatchQueue.main.async {
                    completionHandler(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
}
