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
}

struct Release {
    let date: String?
    let country: String?
}

extension Film {
    init(film: FilmByKeyword, release: FilmWithReleaseDate) {
        // Иногда API возвращает дату релиза в стане несколько раз
        // Очищаем дубликаты: страна - дата
        // Также фильтруем страны, где релиз неизвестен
        let releases = release.items.reduce([]) { array, item -> [Release] in
            var array = array
            
            if !array.contains(where: {
                $0.country == item.country?.country && $0.date == item.date
            }) {
                
                array.append(Release(date: item.date, country: item.country?.country))
            }
            
            return array
        }.filter { release in
            release.date != nil
        }
        
        self.init(
            filmId: film.filmId,
            nameRu: film.nameRu,
            nameEn: film.nameEn,
            description: film.description,
            year: film.year,
            rating: film.rating,
            posterUrlPreview: film.posterUrlPreview,
            releases: releases
        )
    }
}
