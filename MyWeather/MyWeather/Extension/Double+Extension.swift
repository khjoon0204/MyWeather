//
//  UIViewController+Extension.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation

//MARK: Extension+Double
extension Double {
    // kelvin to celsius
    func makeCelsius() -> String {
        let argue = self - 273.15
        return String(format: "%.0f", arguments: [argue])
    }
    
    // kelvin to fahrenheit
    func makeFahrenheit() -> String {
        let argue = (self * 9/5) - 459.67
        return String(format: "%.0f", arguments: [argue])
    }
    
    // rounding double to 2 decimal place
    func makeRound() -> Double {
        return (self * 100).rounded() / 100
    }
}
