//
//  List.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - List
struct ThreeHourForecastList: Codable {
    let dt: Date?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let dtTxt: String?
    let rain: Rain?
    
    var hour: Int {
        get {
            return Calendar.current.dateComponents([.hour], from: dt ?? Date.init(timeIntervalSince1970: 0)).hour ?? 0
        }
    }
}

extension ThreeHourForecastList {
    static var empty: ThreeHourForecastList {
        return ThreeHourForecastList(dt: nil, main: nil, weather: nil, clouds: nil, wind: nil, dtTxt: nil, rain: nil)
    }
}


//// MARK: - List
//struct List: Codable {
//    let dt: Date?
//    let temp: Double?
//    let feelsLike: Double?
//    let pressure: Int?
//    let humidity: Int?
//    let dewPoint: Double?
//    let clouds: Int?
//    let windSpeed: Double?
//    let windDeg: Int?
//    let weather: [Weather]?
//    let rain: Rain?
//
//    enum CodingKeys: String, CodingKey {
//        case dt = "dt"
//        case temp = "temp"
//        case feelsLike = "feels_like"
//        case pressure = "pressure"
//        case humidity = "humidity"
//        case dewPoint = "dew_point"
//        case clouds = "clouds"
//        case windSpeed = "wind_speed"
//        case windDeg = "wind_deg"
//        case weather = "weather"
//        case rain = "rain"
//    }
//
//    var hour: Int {
//        get {
//            return Calendar.current.dateComponents([.hour], from: dt ?? Date.init(timeIntervalSince1970: 0)).hour ?? 0
//        }
//    }
//}
//
//extension List {
//    static var empty: List {
//        return List(dt: nil,
//                      temp: nil,
//                      feelsLike: nil,
//                      pressure: nil,
//                      humidity: nil,
//                      dewPoint: nil,
//                      clouds: nil,
//                      windSpeed: nil,
//                      windDeg: nil,
//                      weather: nil,
//                      rain: nil)
//    }
//}
