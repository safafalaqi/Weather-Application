//
//  CurrentWeatherModel.swift
//  Weather Application
//
//  Created by Safa Falaqi on 24/12/2021.
//

import Foundation

class CurrentWeatherModel{
    
    static func getCurrentWeather(city:String,completionHandler:@escaping  (_ data: Data? , _ response:URLResponse?, _ error:Error?) -> Void){
      
        let l = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=48a0f6a2e82fdf6929188bf6d19cc298"
        
        let urlString =  l.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlString!)else{return}
               let session = URLSession.shared
               let task = session.dataTask(with: url, completionHandler: completionHandler)
               task.resume()
        
        
    }
    
}

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
