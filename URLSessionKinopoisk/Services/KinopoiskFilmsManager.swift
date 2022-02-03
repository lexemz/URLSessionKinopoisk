//
//  KinopoiskFilmsManager.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 03.02.2022.
//

import Foundation

class KinopoiskFilmsManager {
    
    static let shared = KinopoiskFilmsManager()
    
    private let keywordLink = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
    private let filmIDLink = "https://kinopoiskapiunofficial.tech/api/v2.2/films"
    
    private init() {}
    
    private func fetchFilmsList(keyword: String, completionHandler: @escaping ([FoundedFilm]) -> Void){
        
        var urlComps = URLComponents(string: keywordLink)
        let queryItem = URLQueryItem(name: "keyword", value: keyword)
        urlComps?.queryItems = [queryItem]
        
        guard let urlWithComps = urlComps?.url else {
            print("URL IS NOT WALID")
            return
        }
        
        NetworkManager.shared.fetch(model: FoundedFilms.self, from: urlWithComps) { result in
            switch result {
                
            case .success(let films):
                completionHandler(films.films)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchFilmDistributionInfo(filmID: Int, completionHandler: @escaping (FilmWithDistributionInfo) -> Void) {
        let stringURL = "\(filmIDLink)/\(filmID)/distributions"
        guard let urlWithID = URL(string: stringURL) else {
            print("URL IS NOT WALID")
            return
        }
        
        NetworkManager.shared.fetch(model: FilmWithDistributionInfo.self, from: urlWithID) { result in
            switch result {
                
            case .success(let filmDistributionInfo):
                completionHandler(filmDistributionInfo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func findFilmsWithDistributionInfo(name: String, completionHandler: @escaping (Film) -> Void, faulireHandler: @escaping () -> Void) {
        fetchFilmsList(keyword: name) { films in
            let films = films.filter { Int($0.year ?? "") ?? 0 >= 2022 && $0.rating == "null" }
            
            guard films.count != 0 else {
                faulireHandler()
                return
            }
            
            
            dump(films)
            for film in films {
                self.fetchFilmDistributionInfo(filmID: film.filmId) { filmWithDistributionInfo in
                    let film = Film.createFilm(film: film, release: filmWithDistributionInfo)
                    
                    completionHandler(film)
                }
            }
        }
    }
}
