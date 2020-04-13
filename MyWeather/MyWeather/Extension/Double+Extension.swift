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
    func toCelsius() -> String {
        let arg = calculateCelsius(fahrenheit: self)
        return String(format: "%.0f", arguments: [arg])
    }
    
    func toFahrenheit() -> String {
        let arg: Double = self.toFahrenheit()
        return String(format: "%.0f", arguments: [arg])
    }
    
    func toFahrenheit() -> Double {
        let arg = calculateFahrenheit(celsius: self)
        return arg
    }
    
    func calculateCelsius(fahrenheit: Double) -> Double {
        var celsius: Double
        celsius = (fahrenheit - 32) * 5 / 9
        return celsius
    }

    func calculateFahrenheit(celsius: Double) -> Double {
        var fahrenheit: Double
        fahrenheit = celsius * 9 / 5 + 32
        return fahrenheit
    }

    
    // rounding double to 2 decimal place
    func round2Decimal() -> Double {
        return (self * 100).rounded() / 100
    }
    
}
