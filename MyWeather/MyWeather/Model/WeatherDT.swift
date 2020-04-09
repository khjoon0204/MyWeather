//
//  Weather.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/09.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation

struct WeatherDT: Codable {
    var seq: Int = -1
    var latitude: String = ""
    var longitude: String = ""
    var title: String = ""
    
    init(seq: Int, latitude: String, longitude: String, title: String) {
        self.seq = seq
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
    }
}
