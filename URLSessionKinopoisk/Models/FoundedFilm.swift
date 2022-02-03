//
//  Film.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 02.02.2022.
//

import Foundation

struct FoundedFilms: Decodable {
    let films: [FoundedFilm]
}

struct FoundedFilm: Decodable {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let description: String?
    let year: String?
    let rating: String?
    let type: String?
    
    let posterUrlPreview: String?
}
