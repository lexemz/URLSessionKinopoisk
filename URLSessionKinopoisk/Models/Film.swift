//
//  Film.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 03.02.2022.
//

import Foundation

struct Film {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let description: String?
    let year: String?
    let rating: String?
    
    let posterUrlPreview: String?
    
    let releases: [Release]
    
    static func createFilm(film: FoundedFilm, release: FilmWithDistributionInfo) -> Film {
        let releases = release.items.map { item in
            Release(date: item.date, country: item.country?.country)
        }
        
        let film = Film(
            filmId: film.filmId,
            nameRu: film.nameRu,
            nameEn: film.nameEn,
            description: film.description,
            year: film.year,
            rating: film.rating,
            posterUrlPreview: film.posterUrlPreview,
            releases: releases
        )
        return film
    }
}

struct Release {
    let date: String?
    let country: String?
}
