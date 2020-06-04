//
//  NetworkManager.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import RxSwift

protocol NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

final class NetworkManager: NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return URLRequest.load(resource: resource)
    }
}
