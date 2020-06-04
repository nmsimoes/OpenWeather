//
//  Wind.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}
