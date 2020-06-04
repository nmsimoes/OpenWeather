//
//  OpenWeatherViewModel.swift
//  OpenWeather
//
//  Created by Nuno Simões on 31/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import RxCocoa
import RxSwift

final class OpenWeatherViewModel {
    
    private let disposeBag = DisposeBag()
    private let openWeatherApiHandler: OpenWeatherAPIHandler
    private let openWeatherHourly = BehaviorRelay<[ThreeHourForecastList]>(value: [])
    
    var openWeatherNow: Observable<ThreeHourForecastList>
    var openWeatherToday: Observable<[ThreeHourForecastList]>
    var openWeatherTodayPlus1: Observable<[ThreeHourForecastList]>
    var openWeatherTodayPlus2: Observable<[ThreeHourForecastList]>
    var openWeatherTodayPlus3: Observable<[ThreeHourForecastList]>
    var openWeatherTodayPlus4: Observable<[ThreeHourForecastList]>

    init(_ openWeatherApiHandler: OpenWeatherAPIHandler = OpenWeatherAPIHandler()) {
        self.openWeatherApiHandler = openWeatherApiHandler

        self.openWeatherNow = openWeatherHourly.asObservable()
            .flatMap({ (vectorHourly) -> Observable<ThreeHourForecastList> in
                return Observable.just(vectorHourly.first ?? ThreeHourForecastList.empty)
            })
        
        self.openWeatherToday = openWeatherHourly.asObservable()
        self.openWeatherTodayPlus1 = openWeatherHourly.asObservable()
        self.openWeatherTodayPlus2 = openWeatherHourly.asObservable()
        self.openWeatherTodayPlus3 = openWeatherHourly.asObservable()
        self.openWeatherTodayPlus4 = openWeatherHourly.asObservable()

        self.syncTask()
    }
        
    private func syncTask() {

        self.openWeatherToday = openWeatherHourly.asObservable()
            .flatMap { vectorHourly -> Observable<[ThreeHourForecastList]> in
                let hourliesOfToday = self.filterHourlies(from: vectorHourly, toDeltaDay: 0)
                return Observable.just(hourliesOfToday)
            }

        self.openWeatherTodayPlus1 = openWeatherHourly.asObservable()
            .flatMap { vectorHourly -> Observable<[ThreeHourForecastList]> in
                let hourliesOfTomorrow = self.filterHourlies(from: vectorHourly, toDeltaDay: 1)
                return Observable.just(hourliesOfTomorrow)
            }
        
        self.openWeatherTodayPlus2 = openWeatherHourly.asObservable()
            .flatMap { vectorHourly -> Observable<[ThreeHourForecastList]> in
                let hourliesOfTomorrow = self.filterHourlies(from: vectorHourly, toDeltaDay: 2)
                return Observable.just(hourliesOfTomorrow)
            }
        
        self.openWeatherTodayPlus3 = openWeatherHourly.asObservable()
            .flatMap { vectorHourly -> Observable<[ThreeHourForecastList]> in
                let hourliesOfTomorrow = self.filterHourlies(from: vectorHourly, toDeltaDay: 3)
                return Observable.just(hourliesOfTomorrow)
            }
        
        self.openWeatherTodayPlus4 = openWeatherHourly.asObservable()
            .flatMap { vectorHourly -> Observable<[ThreeHourForecastList]> in
                let hourliesOfTomorrow = self.filterHourlies(from: vectorHourly, toDeltaDay: 4)
                return Observable.just(hourliesOfTomorrow)
            }

        self.getHourlyWeatherInfo()

        Observable<Int>.interval(.seconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .subscribe(onNext: { _ in
                self.getHourlyWeatherInfo()
            })
            .disposed(by: disposeBag)
    }
    
    private func filterHourlies(from hourlies: [ThreeHourForecastList], toDeltaDay:Int) -> [ThreeHourForecastList] {
        if hourlies.count == 0 { return [] }
        
        guard let utc = TimeZone(identifier: "UTC") else { return [] }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utc

        guard let startDate = hourlies[0].dt else { return [] }
        let startDay = calendar.dateComponents([.day], from: startDate).day ?? 0
            
        let hourliesOfToday = hourlies.filter {
            guard let hourlyDate = $0.dt else { return false }
            let dateComponents = calendar.dateComponents([.day, .hour], from: hourlyDate)
            let hourlyDay = dateComponents.day ?? 0
            let hourlyHour = dateComponents.hour ?? 0

            if startDay + toDeltaDay == hourlyDay && hourlyHour % 3 == 0 {
                return true
            }
            
            return false
        }
        
        return hourliesOfToday
    }
    
    func getHourlyWeatherInfo()  {
        openWeatherApiHandler.getHourlyWeatherInfo()
            .retry(3)
            .catchError { (error) -> Observable<OpenWheater5DaysForecast?> in
                print(error.localizedDescription)
                return Observable.just(OpenWheater5DaysForecast.empty)
            }
            .subscribe(onNext: { fiveDayHourlyForecast in
                if let hourly = fiveDayHourlyForecast?.threeHourForecastList {
                    let sortedHourly = hourly.sorted { (h1, h2) -> Bool in
                        guard let firstDate = h1.dt else { return false }
                        guard let secondDate = h2.dt else { return false }
                        return firstDate.compare(secondDate) == ComparisonResult.orderedAscending ? true : false
                    }
                    self.openWeatherHourly.accept(sortedHourly)
                }
            }, onError: { (error) in
                print("getHourlyWeatherInfo onError: \(error)")
            })
            .disposed(by: disposeBag)
    }

    /// MARK public methods
    
    public func getWheatherDataModel(_ hourly: ThreeHourForecastList) -> WheatherDataModel? {
        return WheatherDataModel(hourly)
    }
    
}
