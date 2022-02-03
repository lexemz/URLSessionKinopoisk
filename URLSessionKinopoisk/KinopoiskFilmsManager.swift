//
//  KinopoiskFilmsManager.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 03.02.2022.
//

import Foundation

class KinopoiskFilmsManager {
    
    private let keywordLink = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
    private let filmIDLink = "https://kinopoiskapiunofficial.tech/api/v2.2/films"
    
    func fetchFilmsList(keyword: String, completionHandler: @escaping ([Film]) -> Void){
        
        var urlComps = URLComponents(string: keywordLink)
        let queryItem = URLQueryItem(name: "keyword", value: keyword)
        urlComps?.queryItems = [queryItem]
        
        guard let urlWithComps = urlComps?.url else {
            print("URL IS NOT WALID")
            return
        }
        
        NetworkManager.shared.fetchFilms(from: urlWithComps) { result in
            switch result {
                
            case .success(let films):
                completionHandler(films.films)
            case .failure(let error):
                print(error)
            }
        }
    }
}
