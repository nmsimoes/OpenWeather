//
//  MainClass.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case tempKf = "temp_kf"
    }
}
