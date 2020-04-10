//
//  UIViewController+Extension.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday 
    }
    
    func dayNumberOfWeek(time: Int) -> Int? {
        guard let timeZone = TimeZone(abbreviation: calculateGMT(time: time)) else {
            return 0
        }
        return Calendar.current.dateComponents(in: timeZone, from: self).weekday
    }
    
    func calculateGMT(time: Int) -> String {
        let timeZone = abs(time) / 3600
        let compare = time < 0 ? "-" : "+" 

        if timeZone < 10 {
            return "GMT\(compare)0\(timeZone)"
        } else {
            return "GMT\(compare)\(timeZone)"
        }
    }
    
    func getCountryTime(byTimeZone time: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        formatter.timeZone = TimeZone(abbreviation: calculateGMT(time: time))        
        return formatter.string(from: self)
    }
}
