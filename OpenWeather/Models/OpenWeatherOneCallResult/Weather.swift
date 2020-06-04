//
//  Weather.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

