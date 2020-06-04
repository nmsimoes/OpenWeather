//
//  DayForecast.swift
//  OpenWeather
//
//  Created by Nuno Simões on 02/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DayForecast: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum WeekdayType {
        case today
        case tomorrow
        case weekday
    }
    
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var cvForecast: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    private let itemSize = CGSize(width: 50, height: 90)

    fileprivate let openWeatherDayForecast = BehaviorRelay<[ThreeHourForecastList]>(value: [])
    
    private var dataSource: [ThreeHourForecastList] = []
    private var title: String?
    
    var weekdayType = WeekdayType.today

    override func awakeFromNib() {
        super.awakeFromNib()

        self.cvForecast.register(UINib(nibName:"DayForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DayForecastCollectionViewCell.reuseIdentifier)
        self.cvForecast.delegate = self
        self.cvForecast.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.cvForecast.collectionViewLayout = layout
        
        self.openWeatherDayForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (threeHourForecastList) in
                self.dataSource = threeHourForecastList
                self.cvForecast.reloadData()
                self.updateTitle()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTitle() {
        guard let firstDate = self.dataSource.first?.dt else { return }

        dateFormatter.dateFormat = "LLLL"
        let monthName = dateFormatter.string(from: firstDate)

        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: firstDate)

        switch weekdayType {
        case .tomorrow:
            self.lblDay.text = "Tomorrow, \(monthName) \(day)"
            break;

        case.weekday:
            dateFormatter.dateFormat = "EEEE"
            self.lblDay.text = "\(dateFormatter.string(from: firstDate)), \(monthName) \(day)"
            break;

        case .today:
            fallthrough
        default:
            self.lblDay.text = "Today, \(monthName) \(day)"

        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayForecastCollectionViewCell.reuseIdentifier, for: indexPath) as! DayForecastCollectionViewCell
        cell.addHourForecast(weatherDataModel: WheatherHourDataModel(self.dataSource[indexPath.row])!)
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
}

extension Reactive where Base: DayForecast {
  var forecastData: Binder<[ThreeHourForecastList]> {
    return Binder(self.base) { view, threeHourForecastList in
        view.openWeatherDayForecast.accept(threeHourForecastList)
    }
  }
}
