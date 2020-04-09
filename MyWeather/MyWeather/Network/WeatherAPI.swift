//
//  WeatherAPI.swift
//  NetworkingLayer
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation

enum WeatherAPI {
    case onecall(lat: String, lon: String)
}

extension WeatherAPI: EndpointType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }

    var path: String {
        switch self {
        case .onecall(let lat, let lon):
            return "/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(OPENWEATHERMAP_API_KEY)&units=metric&lang=kr"
        }
    }
}
