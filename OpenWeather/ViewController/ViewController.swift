//
//  ViewController.swift
//  OpenWeather
//
//  Created by Nuno Simões on 29/05/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import RxSwift
import UIKit

class OpenWeatherViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let dayForecastHeight = CGFloat(140)
    
    var viewModel: OpenWeatherViewModel = OpenWeatherViewModel()
    
    @IBOutlet weak var stackViewContent: UIStackView!
    @IBOutlet private weak var imgWeatherIcon: UIImageView!
    @IBOutlet private weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblFeelsLike: UILabel!
    @IBOutlet weak var dotChart: DotChart!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupViewModel()
    }
        
    private func setupViewModel() {
        self.viewModel.openWeatherNow
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { hourly in
                self.updateTodayWeather(hourly)
            }, onError: { (error) in
                print("onError: \(error)")
            })
        .disposed(by: disposeBag)

        guard let utc = TimeZone(identifier: "UTC") else { return }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utc

        self.viewModel.openWeatherToday
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .map {
                $0.compactMap {
                    let hour = calendar.dateComponents([.hour], from: $0.dt ?? Date.init(timeIntervalSince1970: 0)).hour
                    return (String(format: "%02d:00", hour!), $0.main?.temp ?? 0)
                }
            }
            .drive( dotChart.rx.temperatureValues )
            .disposed(by: disposeBag)
        
        let dayForecast1: DayForecast = UIView.fromNib()
        dayForecast1.heightAnchor.constraint(equalToConstant: dayForecastHeight).isActive = true
        dayForecast1.weekdayType = .tomorrow
        self.stackViewContent.addArrangedSubview(dayForecast1)

        self.viewModel.openWeatherTodayPlus1
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(dayForecast1.rx.forecastData)
            .disposed(by: disposeBag)
                
        let dayForecast2: DayForecast = UIView.fromNib()
        dayForecast2.heightAnchor.constraint(equalToConstant: dayForecastHeight).isActive = true
        dayForecast2.weekdayType = .weekday
        self.stackViewContent.addArrangedSubview(dayForecast2)

        self.viewModel.openWeatherTodayPlus2
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(dayForecast2.rx.forecastData)
            .disposed(by: disposeBag)
        
        let dayForecast3: DayForecast = UIView.fromNib()
        dayForecast3.heightAnchor.constraint(equalToConstant: dayForecastHeight).isActive = true
        dayForecast3.weekdayType = .weekday
        self.stackViewContent.addArrangedSubview(dayForecast3)

        self.viewModel.openWeatherTodayPlus3
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(dayForecast3.rx.forecastData)
            .disposed(by: disposeBag)
        
        let dayForecast4: DayForecast = UIView.fromNib()
        dayForecast4.heightAnchor.constraint(equalToConstant: dayForecastHeight).isActive = true
        dayForecast4.weekdayType = .weekday
        self.stackViewContent.addArrangedSubview(dayForecast4)

        self.viewModel.openWeatherTodayPlus4
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(dayForecast4.rx.forecastData)
            .disposed(by: disposeBag)
    }
    
    private func updateTodayWeather(_ hourly: ThreeHourForecastList) {
        guard let weatherDataModel = viewModel.getWheatherDataModel(hourly) else { return }
        
        self.lblCurrentTemp.text = weatherDataModel.temperature
        self.lblFeelsLike.text = weatherDataModel.feelsLike
        self.imgWeatherIcon.setImage(url: weatherDataModel.iconURL)
        
    }
}

