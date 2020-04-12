//
//  WeeklyCollectionViewCell.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class WeeklyCollectionViewCell: UICollectionViewCell {
    private var dt: OnecallWeather?
    @IBOutlet weak var weeklyStack: UIStackView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var etcStack: UIStackView!
    
    func config(OnecallWeather d: OnecallWeather?){
        guard let d = d, let cur = d.current else { return }
        dt = d
        
        let weatherDesc = cur.weather?.first?.weatherDescription
        var temp = isCelsius ? "\(cur.temp!)" : cur.temp?.toFahrenheit()
        temp = "\(temp!)°"
        desc.text = "오늘: 현재 날씨 대체로 흐림, 최고 기온은 16°입니다. 오늘 밤 날씨 청명함, 최저 기온은 4°입니다." // mock
        for day in d.daily! {
            let v = loadViewFromNib(nibName: "WeeklyView") as! WeeklyView
            let date_weekday = Date(timeIntervalSince1970: Double(day.dt ?? 0))
            v.dayOfWeek.text = WeekDay(rawValue: date_weekday.dayNumberOfWeek()!)?.StringValue
            v.weatherDesc.text = day.weather?.first?.weatherDescription
            v.temp_max.text = String(format: "%.0f", floor(day.temp!.max!))
            v.temp_min.text = String(format: "%.0f", floor(day.temp!.min!))
            weeklyStack.addArrangedSubview(v)
        }
        
        let l0 = loadViewFromNib(nibName: "EtcView") as! EtcView
        let date_sunris = Date(timeIntervalSince1970: Double(cur.sunrise ?? 0))
        let date_sunset = Date(timeIntervalSince1970: Double(cur.sunset ?? 0))
        l0.title0.text = "일출"
        l0.title1.text = "일몰"
        l0.desc0.text = getDateTime(date: date_sunris)
        l0.desc1.text = getDateTime(date: date_sunset)
        etcStack.addArrangedSubview(l0)
        let l1 = loadViewFromNib(nibName: "EtcView") as! EtcView
        l1.title0.text = "비 올 확률"
        l1.title1.text = "습도"
//        l1.desc0.text = "\()%"
        l1.desc1.text = "\(cur.humidity!)%"
        etcStack.addArrangedSubview(l1)
        let l2 = loadViewFromNib(nibName: "EtcView") as! EtcView
        l2.title0.text = "바람"
        l2.title1.text = "체감"
        l2.desc0.text = "\(cur.windDeg!) \(cur.windSpeed!)m/s"
        l2.desc1.text = "\(cur.feelsLike!)°"
        etcStack.addArrangedSubview(l2)
        let l3 = loadViewFromNib(nibName: "EtcView") as! EtcView
        l3.title0.text = "강수량"
        l3.title1.text = "기압"
        l3.desc0.text = "\(cur.rain?.the1H ?? 0)cm"
        l3.desc1.text = "\(cur.pressure!)hPa"
        etcStack.addArrangedSubview(l3)
        let l4 = loadViewFromNib(nibName: "EtcView") as! EtcView
        l4.title0.text = "가시거리"
        l4.title1.text = "자외선 지수"
        l4.desc0.text = "\(cur.visibility!)km"
        l4.desc1.text = "\(cur.uvi!)"
        etcStack.addArrangedSubview(l4)
        layoutIfNeeded()
    }
    
    private func getDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: date)
    }
}
