//
//  WheatherResultDataModel.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import Foundation

struct WheatherDataModel {
    let temperature: String
    let feelsLike: String
    let iconURL: URL
    let description: String

    init?(_ data: ThreeHourForecastList) {
        guard let temp = data.main?.temp,
            let feels = data.main?.feelsLike,
            let weatherData = data.weather?.first,
            let image = data.weather?.first?.icon,
            let imageUrl = URL.iconURL(image) else { return nil }

        self.temperature = "Now \(temp) °C"
        self.feelsLike = "Feels like \(feels) °C"
        self.iconURL = imageUrl
        self.description = weatherData.weatherDescription
    }
}
