//
//  WeatherDataManager.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

/**
 Data Key for Parsing
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
    
    private var ws: [OnecallWeather] = []
    public var weathers: [OnecallWeather]{
        get{return ws}
    }
    
    override init() {
        print(#function)
        
    }
    
    /// API -> Memory Array
    /// - Parameters:
    ///   - latitude: <#latitude description#>
    ///   - longitude: <#longitude description#>
    ///   - title: <#title description#>
    ///   - completion: <#completion description#>
    func getOnecallWeather(
        latitude: String, longitude: String,
        title: String,
        completion: ((Bool) -> Void)?){
        
        networking.performNetworkTask(endpoint: WeatherAPI.onecall(lat: latitude, lon: longitude), type: OnecallWeather.self, completion: { (response) in
            let w: OnecallWeather = response
            w.title = title
            w.latitude = latitude
            w.longitude = longitude
            w.seq = self.ws.count
            self.ws.append(w)
            completion?(true)
        }) { (errorMessage) in
            print(errorMessage)
            completion?(false)
        }
        
    }
    
    private func parseToWeatherDT(weather w: OnecallWeather) -> WeatherDT{
        return WeatherDT(seq: w.seq!, latitude: w.latitude!, longitude: w.longitude!, title: w.title!)
    }
    
    func sortBySeq(){
        ws = ws.sorted(by: { (a, b) -> Bool in
            a.seq! > b.seq!
        })
    }
    
    /// Memory Array -> Local Data
    func saveWeatherArray(){
        let dts = weathers.map{return parseToWeatherDT(weather: $0)}
        print("saveWeatherArray=\(dts.count)")
        save(dts: dts)
    }
    
    /// Local Data -> Memory Array
    let group = DispatchGroup.init()
    let queue = DispatchQueue.global()
    func loadWeatherArray(completion: ((Bool) -> Void)?){
        guard let dts = load(), dts.count > 0 else { return }
        for d in dts {
            group.enter()
            queue.async {
                self.getOnecallWeather(latitude: d.latitude, longitude: d.longitude, title: d.title) { (success) in
                    self.group.leave()
                }
            }
        }
        group.notify(queue: queue) {
            print("group leave done!")
            completion?(true)
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
