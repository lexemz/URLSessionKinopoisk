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
    
    func findFilmsWithDistributionInfo(name: String, completionHandler: @escaping ([Film]) -> Void, faulireHandler: @escaping () -> Void) {
        
        fetchFilmsList(keyword: name) { films in
            let upcomingFilms = films.filter { Int($0.year ?? "") ?? 0 >= self.getCurrentYear() && $0.rating == "null" }
            
            guard upcomingFilms.count != 0 else {
                faulireHandler()
                return
            }
            
            var films: [Film] = []
            dump(films)
            for film in upcomingFilms {
                self.fetchFilmDistributionInfo(filmID: film.filmId) { filmWithDistributionInfo in
                    let film = Film.createFilm(film: film, release: filmWithDistributionInfo)
                    
                    films.append(film)
                    if films.count  == upcomingFilms.count {
                        completionHandler(films)
                        
                    }
                }
            }
        }
    }
    
    private func fetchFilmsList(keyword: String, completionHandler: @escaping ([FilmByKeyword]) -> Void){
        
        let queryItem = URLQueryItem(name: "keyword", value: keyword)
        
        NetworkManager.shared.fetchWithComponents(FilmsByKeyword.self, from: keywordLink, with: [queryItem]) { result in
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
        
        NetworkManager.shared.fetch(FilmWithDistributionInfo.self, from: stringURL) { result in
            switch result {
                
            case .success(let filmDistributionInfo):
                completionHandler(filmDistributionInfo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
}
