//
//  URL+Extensions.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// pecker:ignore all
extension URL {
    static func urlFor5DaysForecast() -> URL? {
        return URL(string: ApiParams.baseURL + "data/2.5/forecast?id=2735943&appid=\(ApiParams.appId)&units=\(ApiParams.unitMetric)&lang=\(ApiParams.Languages.PT.rawValue)")
    }

    static func iconURL(_ icon: String) -> URL? {
        return URL(string: ApiParams.iconBaseURL + "img/wn/\(icon)@2x.png")
    }
}

//https://api.openweathermap.org/data/2.5/forecast?id=2735943&appid=e5fe4a319aaf9a175eea37c243bea8da&units=metric&lang=pt
// imperial °F or metric °C

struct ApiParams {
    static let appId = "e5fe4a319aaf9a175eea37c243bea8da"
    static let baseURL = "https://api.openweathermap.org/"
    static let iconBaseURL = "http://openweathermap.org/"

    static let unitMetric = "metric"
    static let unitImperial = "imperial"
    
    enum Languages : String {
        case PT = "pt"
    }
    
}
