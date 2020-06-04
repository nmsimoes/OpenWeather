//
//  NetworkError.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case unknown
    case timeout
}
