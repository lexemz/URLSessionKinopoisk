//
//  Film.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 02.02.2022.
//

import Foundation

struct Films: Decodable {
    let pagesCount: Int
    let films: [Film]
}

struct Film: Decodable {
    let filmId: Int?
    let nameRu: String?
    let nameEn: String?
    let description: String?
    let type: String?
    let year: String?
    
    let posterUrlPreview: String?
}
