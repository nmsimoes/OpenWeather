//
//  City.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
