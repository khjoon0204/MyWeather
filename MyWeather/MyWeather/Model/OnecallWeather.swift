//
//  OneWeather.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//   let oneWeather = try? newJSONDecoder().decode(OneWeather.self, from: jsonData)

import Foundation

// MARK: - OneWeather
class OnecallWeather: Codable {
    /// setter
    var seq: Int? = -1
    var title: String? = ""
    var latitude: String? = ""
    var longitude: String? = ""
    
    let lat, lon: Double?
    let timezone: String?
    let current: Current?
    let hourly: [Hourly]?
    let daily: [Daily]?
    
    init(lat: Double?, lon: Double?, timezone: String?, current: Current?, hourly: [Hourly]?, daily: [Daily]?) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.current = current
        self.hourly = hourly
        self.daily = daily
    }
}

// MARK: - Current
class Current: Codable {
    let dt, sunrise, sunset: Int?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint, uvi: Double?
    let clouds, visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
    }
    
    init(dt: Int?, sunrise: Int?, sunset: Int?, temp: Double?, feelsLike: Double?, pressure: Int?, humidity: Int?, dewPoint: Double?, uvi: Double?, clouds: Int?, visibility: Int?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?, rain: Rain?) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.rain = rain
    }
}

// MARK: - Rain
class Rain: Codable {
    let the1H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    
    init(the1H: Double?) {
        self.the1H = the1H
    }
}

// MARK: - Weather
class Weather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(id: Int?, main: String?, weatherDescription: String?, icon: String?) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}
//enum Main: String, Codable {
//    case clear = "Clear"
//    case clouds = "Clouds"
//    case fog = "Fog"
//    case rain = "Rain"
//}

// MARK: - Daily
class Daily: Codable {
    let dt, sunrise, sunset: Int?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?
    let clouds: Int?
    let rain, uvi: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, rain, uvi
    }
    
    init(dt: Int?, sunrise: Int?, sunset: Int?, temp: Temp?, feelsLike: FeelsLike?, pressure: Int?, humidity: Int?, dewPoint: Double?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?, clouds: Int?, rain: Double?, uvi: Double?) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.clouds = clouds
        self.rain = rain
        self.uvi = uvi
    }
}

// MARK: - FeelsLike
class FeelsLike: Codable {
    let day, night, eve, morn: Double?
    
    init(day: Double?, night: Double?, eve: Double?, morn: Double?) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

// MARK: - Temp
class Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
    
    init(day: Double?, min: Double?, max: Double?, night: Double?, eve: Double?, morn: Double?) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

// MARK: - Hourly
class Hourly: Codable {
    let dt: Int?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint: Double?
    let clouds: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
    }
    
    init(dt: Int?, temp: Double?, feelsLike: Double?, pressure: Int?, humidity: Int?, dewPoint: Double?, clouds: Int?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?, rain: Rain?) {
        self.dt = dt
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.clouds = clouds
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.rain = rain
    }
}
