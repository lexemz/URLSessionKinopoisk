//
//  Calendar.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 18.04.2022.
//

import Foundation

class CalendarManager {
    static let shared = CalendarManager()
    
    private init() {}
    
    var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
}
