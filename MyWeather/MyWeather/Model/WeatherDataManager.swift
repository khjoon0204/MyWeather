//
//  WeatherDataManager.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation

struct WeatherDT: Codable {
    let seq: Int
    let latitude: Double?
    let longitude: Double?
    
    init(seq: Int, latitude: Double?, longitude: Double?) {
        self.seq = seq
        self.latitude = latitude
        self.longitude = longitude
    }
}

class WeatherDataManager: NSObject {
    public static let shared = WeatherDataManager()
    
    private var ws: [OneWeather] = []
    public var weathers: [OneWeather]{
        get{return ws}
    }
    
    private let WEATHER_ARR_KEY = "kArrKey"
    
    typealias WeatherDTs = [WeatherDT]

    override init() {
        print(#function)
        //TODO: - localdata geo정보로 api쿼리 데이터[OneWeather] ws에 할당
    }
    
    private func parseToData(seq: Int, weather: OneWeather) -> WeatherDT{
        return WeatherDT(seq: seq, latitude: weather.lat, longitude: weather.lon)
    }
    
    func addLast(weather: OneWeather){
        ws.append(weather)
        var dts: WeatherDTs = self.getArray() ?? []
        let dt = parseToData(seq: dts.count, weather: weather)
        dts.append(dt)
        save(dts: dts)
    }
    
    private func getArray() -> WeatherDTs?{
        return load()
    }
    
    func setArray(weathers: [OneWeather]){
        ws = weathers
        let dts = weathers.map{return parseToData(seq: $0.seq, weather: $0)}
        save(dts: dts)
    }
    
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
