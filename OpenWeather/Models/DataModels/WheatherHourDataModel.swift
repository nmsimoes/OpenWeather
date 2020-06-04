//
//  WheatherHourDataModel.swift
//  OpenWeather
//
//  Created by Nuno Simões on 02/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

struct WheatherHourDataModel {
    let hour: String
    let temperature: String
    let iconURL: URL

    init?(_ data: ThreeHourForecastList) {
        guard let utc = TimeZone(identifier: "UTC") else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utc

        guard let hour = calendar.dateComponents([.hour], from: data.dt ?? Date.init(timeIntervalSinceNow: 0)).hour,
            let temp = data.main?.temp,
            let image = data.weather?.first?.icon,
            let imageUrl = URL.iconURL(image) else { return nil }

        self.hour = String(format: "%02d", hour)
        self.temperature = String(format: "%.0f°", round(temp))
        self.iconURL = imageUrl
    }
}
