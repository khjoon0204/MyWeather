//
//  HourlyCollectionViewCell.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/12.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    private var dt: Hourly?
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(Hourly d: Hourly?){
        guard let d = d else { return }
        dt = d
        let date = Date(timeIntervalSince1970: Double(d.dt ?? 0))
        time.text = getDateTime(date: date)
        weather.text = d.weather?.first?.weatherDescription        
        let temp = isCelsius ? "\(d.temp!)" : d.temp?.toFahrenheit()
        temperature.text = "\(temp!)°"
    }

    func getDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h시"
        return dateFormatter.string(from: date)
    }
    
}
