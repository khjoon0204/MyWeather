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

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case uvi, clouds, visibility
        case windSpeed
        case windDeg
        case weather
    }

    init(dt: Int?, sunrise: Int?, sunset: Int?, temp: Double?, feelsLike: Double?, pressure: Int?, humidity: Int?, dewPoint: Double?, uvi: Double?, clouds: Int?, visibility: Int?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?) {
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
    }
}

// MARK: - Weather
class Weather: Codable {
    let id: Int?
    let main: Main?
    let weatherDescription: Description?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription
        case icon
    }

    init(id: Int?, main: Main?, weatherDescription: Description?, icon: String?) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case 구름조금 = "구름조금"
    case 맑음 = "맑음"
    case 보통비 = "보통 비"
    case 약간의구름이낀하늘 = "약간의 구름이 낀 하늘"
    case 온흐림 = "온흐림"
    case 튼구름 = "튼구름"
}

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
    let uvi, rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case windSpeed
        case windDeg
        case weather, clouds, uvi, rain
    }

    init(dt: Int?, sunrise: Int?, sunset: Int?, temp: Temp?, feelsLike: FeelsLike?, pressure: Int?, humidity: Int?, dewPoint: Double?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?, clouds: Int?, uvi: Double?, rain: Double?) {
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
        self.uvi = uvi
        self.rain = rain
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

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case clouds
        case windSpeed
        case windDeg
        case weather
    }

    init(dt: Int?, temp: Double?, feelsLike: Double?, pressure: Int?, humidity: Int?, dewPoint: Double?, clouds: Int?, windSpeed: Double?, windDeg: Int?, weather: [Weather]?) {
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
    }
}
