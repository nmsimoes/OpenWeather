//
//  OpenWheater5DaysForecast.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - OpenWheater5DaysForecast
struct OpenWheater5DaysForecast: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let threeHourForecastList: [ThreeHourForecastList]?
    let city: City?

    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case threeHourForecastList = "list"
        case city = "city"
    }
}

extension OpenWheater5DaysForecast {
    static var empty: OpenWheater5DaysForecast {
        return OpenWheater5DaysForecast(cod: nil, message: nil, cnt: nil, threeHourForecastList: nil, city: nil)
    }
}

