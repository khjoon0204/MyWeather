//
//  WeatherDataManager.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

/**
 - Data Key for Parsing
 MKSearch - title, latitude, longitude
 OneCall(api) - lat, lon (공통날씨구간. 소숫점두자리내)
 LocalData(WeatherDT) - seq, latitude, longitude, title
 ViewModel - seq, title, lat, lon
 */

import Foundation

class WeatherDataManager: NSObject {
    private let WEATHER_ARR_KEY = "kWeatherArrKey"
    
    public static let shared = WeatherDataManager()
    
    private let networking = Networking()
    
    private var ws: [String:OnecallWeather] = [:]
    public var weathers: [String:OnecallWeather]{ // Key: latitude+longitude
        get{return ws}
    }
    
    override init() {
        print(#function)
        
    }
    
    /// API -> Memory Dictionary
    /// - Parameters:
    ///   - latitude: <#latitude description#>
    ///   - longitude: <#longitude description#>
    ///   - title: <#title description#>
    ///   - completion: <#completion description#>
    func getOnecallWeather(
        latitude: String, longitude: String,
        title: String,
        completion: ((Bool) -> Void)?){
        networking.performNetworkTask(endpoint: WeatherAPI.onecall(lat: latitude, lon: longitude), type: OnecallWeather.self) { (response) in
            let w: OnecallWeather = response
            w.title = title
            w.latitude = latitude
            w.longitude = longitude
            self.ws["\(latitude+longitude)"] = w
            completion?(true)
        }
    }
    
    private func parseToWeatherDT(seq: Int, weather w: OnecallWeather) -> WeatherDT{
        return WeatherDT(seq: seq, latitude: w.latitude, longitude: w.longitude, title: w.title)
    }
    
    /// Memory Dictionary -> Local Data
    func saveWeatherDictionary(){
        let dts = weathers.map{ k, v in
            return parseToWeatherDT(seq: v.seq, weather: v)
        }
        save(dts: dts)
    }
    
    /// Local Data -> Memory Dictionary
    func loadWeatherDictionary(){
        guard let dts = load() else { return }
        let group = DispatchGroup.init()
        let queue = DispatchQueue.global()
        group.enter()
        queue.async {
            for d in dts {
                self.getOnecallWeather(latitude: d.latitude, longitude: d.longitude, title: d.title) { (success) in
                    group.leave()
                }
            }
        }
        group.notify(queue: queue) {
            DispatchQueue.main.async(execute: {
                self.saveWeatherDictionary()
            })
        }
    }
    
    
    // MARK: - Local Database
    typealias WeatherDTs = [WeatherDT]
    
    private func save(dts: WeatherDTs){
        let encodedData = try? PropertyListEncoder().encode(dts)
        UserDefaults.standard.set(encodedData, forKey:WEATHER_ARR_KEY)
        UserDefaults.standard.synchronize();
    }
    
    private func load() -> WeatherDTs?{
        if let data = UserDefaults.standard.value(forKey:WEATHER_ARR_KEY) as? Data {
            return try? PropertyListDecoder().decode(WeatherDTs.self, from:data)
        }
        return nil
    }
    
}
