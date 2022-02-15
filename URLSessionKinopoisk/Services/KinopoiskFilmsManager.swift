//
//  KinopoiskFilmsManager.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 03.02.2022.
//

import Foundation

enum KinopoiskFilmsManagerError: Error {
    case noFilms
}

final class KinopoiskFilmsManager {
    
    static let shared = KinopoiskFilmsManager()
    
    private let keywordLink = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
    private let filmIDLink = "https://kinopoiskapiunofficial.tech/api/v2.2/films"
    
    private init() {}
    
    func findFilmsWithDistributionInfo(
        name: String,
        completionHandler: @escaping ([Film]) -> Void,
        faulireHandler: @escaping (Error) -> Void
    ) {
        
        fetchFilmsList(keyword: name) { result in
            switch result {
                
            case .success(let films):
                let upcomingFilms = films.filter { Int($0.year ?? "") ?? 0 >= self.getCurrentYear() && $0.rating == "null" }
                
                guard upcomingFilms.count != 0 else {
                    let noFilmsError = KinopoiskFilmsManagerError.noFilms
                    
                    Log.error(noFilmsError)
                    faulireHandler(noFilmsError)
                    return
                }
                
//                Log.debug(films)
                var films: [Film] = []
                
                for film in upcomingFilms {
                    self.fetchFilmDistributionInfo(filmID: film.filmId) { result in
                        switch result {
                            
                        case .success(let filmWithDistributionInfo):
                            let film = Film.uniteFilmAndReleaseInfo(film: film, release: filmWithDistributionInfo)
                            
                            films.append(film)
                            if films.count  == upcomingFilms.count {
                                completionHandler(films)
                            }
                        case .failure(let error):
                            Log.error(error)
                        }
                    }
                }
            case .failure(let error):
                Log.error(error)
                faulireHandler(error)
            }
            
        }
    }
    
    private func fetchFilmsList(keyword: String, completionHandler: @escaping (Result<[FilmByKeyword], NetworkError>) -> Void){
        
        let queryItem = URLQueryItem(name: "keyword", value: keyword)
        
        NetworkManager.shared.fetchWithComponents(FilmsByKeyword.self, from: keywordLink, with: [queryItem]) { result in
            switch result {
                
            case .success(let films):
                completionHandler(.success(films.films))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func fetchFilmDistributionInfo(filmID: Int, completionHandler: @escaping (Result<FilmWithReleaseDate, NetworkError>) -> Void) {
        let stringURL = "\(filmIDLink)/\(filmID)/distributions"
        
        NetworkManager.shared.fetch(FilmWithReleaseDate.self, from: stringURL) { result in
            switch result {
                
            case .success(let filmDistributionInfo):
                completionHandler(.success(filmDistributionInfo))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
}

