//
//  WeatherCodable.swift
//  weatherApp
//
//  Created by Iskhak Zhutanov on 11/11/22.
//

struct WeatherCodable: Codable {
    var weather: [Weather]
    var main: WeatherMain
    var wind: Wind
    var name: String
    var sys: SysData
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WeatherMain: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
    var sea_level: Double?
    var grnd_level: Double?
}

struct Wind: Codable {
    var speed: Double
    var deg: Double
    var gust: Double?
}

struct SysData: Codable {
    var country: String
}
