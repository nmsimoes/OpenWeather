//
//  OpenWeatherAPIHandler.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import RxSwift

class OpenWeatherAPIHandler {

    private let networkingManager: NetworkingManager
    
    init(_ networkingManager: NetworkingManager = NetworkManager()) {
        self.networkingManager = networkingManager
    }
    
    func getHourlyWeatherInfo() -> Observable<OpenWheater5DaysForecast?> {
        let url = URL.urlFor5DaysForecast()!

        let resource = Resource<OpenWheater5DaysForecast>(url: url)

        return networkingManager.load(resource: resource)
            .map { article -> OpenWheater5DaysForecast? in
                article
            }
            .asObservable()
            .retry(2)
    }

}

