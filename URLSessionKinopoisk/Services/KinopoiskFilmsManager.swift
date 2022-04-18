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
        completionHandler: @escaping (Result<[Film], Error>) -> Void
    ) {
        fetchFilmsList(keyword: name) { [weak self] result in
            switch result {
            case .success(let films):
                let upcomingFilms = films.filter { $0.notReleased }

                guard upcomingFilms.count != 0 else {
                    let noFilmsError = KinopoiskFilmsManagerError.noFilms
                    completionHandler(.failure(noFilmsError))
                    return
                }

                var films: [Film] = []

                for film in upcomingFilms {
                    self?.fetchFilmDistributionInfo(filmID: film.filmId) { result in
                        switch result {
                        case .success(let filmWithDistributionInfo):
                            let film = Film(film: film, release: filmWithDistributionInfo)

                            films.append(film)
                            if films.count == upcomingFilms.count {
                                completionHandler(.success(films))
                            }
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                Logger.error(error)
                completionHandler(.failure(error))
            }
        }
    }
    
    
    typealias ResultWithFilms = Result<[FilmByKeyword], NetworkError>
    private func fetchFilmsList(
        keyword: String,
        completionHandler: @escaping (ResultWithFilms) -> Void
    ) {
        let queryItem = URLQueryItem(name: "keyword", value: keyword)
        
        NetworkManager.shared.fetchWithComponents(
            FilmsByKeyword.self,
            from: keywordLink,
            with: [queryItem]
        ) { result in
            switch result {
            case .success(let films):
                completionHandler(.success(films.films))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    typealias ResultWithFilmReleaseDate = Result<FilmWithReleaseDate, NetworkError>
    private func fetchFilmDistributionInfo(
        filmID: Int,
        completionHandler: @escaping (ResultWithFilmReleaseDate) -> Void
    ) {
        let stringURL = "\(filmIDLink)/\(filmID)/distributions"
        
        NetworkManager.shared.fetch(
            FilmWithReleaseDate.self,
            from: stringURL
        ) { result in
            switch result {
            case .success(let filmDistributionInfo):
                completionHandler(.success(filmDistributionInfo))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
