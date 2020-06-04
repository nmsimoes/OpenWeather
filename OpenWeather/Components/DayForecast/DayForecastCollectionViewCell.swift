//
//  DayForecastCollectionViewCell.swift
//  OpenWeather
//
//  Created by Nuno Simões on 02/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import UIKit

class DayForecastCollectionViewCell: UICollectionViewCell {
 
    static let reuseIdentifier = "HourForecast"
    
    @IBOutlet weak var imgWheaterIcon: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblHour: UILabel!

    override func awakeFromNib() {
        _ = 0
    }
    
    func addHourForecast(weatherDataModel: WheatherHourDataModel) {
        self.imgWheaterIcon.setImage(url: weatherDataModel.iconURL)
        self.lblTemperature.text = weatherDataModel.temperature
        self.lblHour.text = weatherDataModel.hour
    }
}
