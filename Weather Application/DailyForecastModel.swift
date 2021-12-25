//
//  DailyForecastModel.swift
//  Weather Application
//
//  Created by Safa Falaqi on 24/12/2021.
//

import Foundation

class DailyForecastModel{
    
    static func getDailyForcast(city:String,completionHandler:@escaping  (_ data: Data? , _ response:URLResponse?, _ error:Error?) -> Void){
        
        //replace occurance of spaces with %20
        let l = "http://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=48a0f6a2e82fdf6929188bf6d19cc298"

        let urlString =  l.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string:urlString!) else {return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler:completionHandler)
        task.resume()
        
        
    }
    
}

// MARK: - DailyForcast
struct DailyForcast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ListDaily]
    let city: CityDaily
}

// MARK: - City
struct CityDaily: Codable {
    let id: Int
    let name: String
    let coord: CoordDaily
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct CoordDaily: Codable {
    let lat, lon: Double
}

// MARK: - List
struct ListDaily: Codable {
    let dt: Int
    let main: MainClassDaily
    let weather: [WeatherDaily]
    let clouds: CloudsDaily
    let wind: WindDaily
    let visibility: Int
    let pop: Double
    let sys: SysDaily
    let dtTxt: String
    let rain, snow: RainDaily?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct CloudsDaily: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClassDaily: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct RainDaily: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct SysDaily: Codable {
    let pod: PodDaily
}

enum PodDaily: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct WeatherDaily: Codable {
    let id: Int
    let main: MainEnumDaily
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnumDaily: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
}

// MARK: - Wind
struct WindDaily: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
