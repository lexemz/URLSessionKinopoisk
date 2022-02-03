//
//  FilmWithInfo.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 03.02.2022.
//

import Foundation

struct FilmWithReleaseDate: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let type: String?
    let subType: String?
    let date: String?
    let reRelease: Bool?
    let country: Country?
}

struct Country: Decodable {
    let country: String?
}
