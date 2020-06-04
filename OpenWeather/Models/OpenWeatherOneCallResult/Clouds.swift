//
//  Clouds.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}
