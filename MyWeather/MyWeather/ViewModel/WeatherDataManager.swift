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
    
    // MARK: - public
    func setWeathersSequence(){
        for i in 0..<ws.count {
            ws[i].seq = i
        }
    }
    
    func removeWeather(at idx: Int){
        ws.remove(at: idx)
    }
    
    func insertWeather(weather w: OnecallWeather, at idx: Int){
        ws.insert(w, at: idx)
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
            self.updateIfExist(weather: w)
            completion?(true)
        }) { (errorMessage) in
            print(errorMessage)
            completion?(false)
        }
        
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
    func loadWeatherArray(completion: ((Bool) -> Void)?){
        guard let dts = load(), dts.count > 0 else {
            return
        }
        for i in dts {
            updateIfExist(weather: parseToOnecallWeather(d: i))
        }
    }
    
    let group = DispatchGroup.init()
    let queue = DispatchQueue.global()
    func updateWeatherArray(completion: ((Bool) -> Void)?){
        guard ws.count > 0 else {
            return
        }
        for i in ws {
            group.enter()
            queue.async {
                self.getOnecallWeather(latitude: i.latitude!, longitude: i.longitude!, title: i.title!) { (success) in
                    self.group.leave()
                }
            }
        }
        group.notify(queue: queue) {
            print("group leave done!")
            completion?(true)
        }
    }
    
    // MARK: - private
    private func updateIfExist(weather w: OnecallWeather){
        if let idx = (ws.firstIndex {$0.title == w.title}){
            ws[idx] = w
        }
        else{ws.append(w)}
    }
    
    private func parseToWeatherDT(weather w: OnecallWeather) -> WeatherDT{
        return WeatherDT(seq: w.seq!, latitude: w.latitude!, longitude: w.longitude!, title: w.title!)
    }
    
    private func parseToOnecallWeather(d: WeatherDT) -> OnecallWeather{
        let ow = OnecallWeather(lat: nil, lon: nil, timezone: nil, current: nil, hourly: nil, daily: nil)
        ow.title = d.title
        ow.latitude = d.latitude
        ow.longitude = d.longitude
        ow.seq = d.seq
        return ow
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
