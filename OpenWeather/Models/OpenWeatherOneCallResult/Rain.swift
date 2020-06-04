//
//  Rain.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

// MARK: - Rain
struct Rain: Codable {
    let volume3H: Double

    enum CodingKeys: String, CodingKey {
        case volume3H = "3h"
    }
}
