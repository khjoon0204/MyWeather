//
//  DetailHeaderTableViewCell.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var userInterV: UIView!
    @IBOutlet weak var nameV: UIView!
    @IBOutlet weak var detailV: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTime: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(OnecallWeather d: OnecallWeather?){
        guard let d = d, let cur = d.current else { return }
        cityName.text = d.title
        let date = Date(timeIntervalSince1970: Double(cur.dt ?? 0))
        cityTime.text = getDateTime(date: date)
        let temp = isCelsius ? cur.temp! : cur.temp?.toFahrenheit()
        cityTemperature.text = String(format: "%.0f°", floor(temp!))
    }
    
    private func getDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: date)
    }
}
