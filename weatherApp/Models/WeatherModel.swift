//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Iskhak Zhutanov on 11/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherModel: NSObject {
    
    let bag = DisposeBag()
    
    private let apiKey = "cd93b58dce3ef8171d0fcd47dc3a64c6"
    
    var cityNameM = PublishSubject<String>()
    var geoCoord = PublishSubject<[Double]>()
    var weatherDataM = PublishSubject<WeatherData>()
    
    override init() {
        super.init()
        
        geoCoord.subscribe(onNext: {
            self.fetchWeatherData(lat: $0[0], lon: $0[1], apiKey: self.apiKey)
        }).disposed(by: bag)
        
        cityNameM.subscribe(onNext: {
            self.fetchGeoCoordinates(city: $0, apiKey: self.apiKey)
        }).disposed(by: bag)
        
    }
    
    func fetchGeoCoordinates(city: String, apiKey: String) {
        let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&appid=\(apiKey)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let geoCoord = try JSONDecoder().decode([GeoCoordinates].self, from: data!)
            
                self.geoCoord.onNext([geoCoord[0].lat, geoCoord[0].lon])
            } catch let error {
                fatalError("error fetching geoCoord \(String(describing: error))")
            }
        }.resume()
    }
    
    func fetchWeatherData(lat: Double, lon: Double, apiKey: String) {
        let units = "metric" //imperial - Fahrenheit, metric - Celsius, standard - Kelvin
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(units)")
        var fetchedData = WeatherData(temperature: 0, maxTemp: 0, minTemp: 0, humidity: 0, windSpeed: 0, mainDesc: "", country: "")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let weatherData = try JSONDecoder().decode(WeatherCodable.self, from: data!)
                fetchedData.temperature = weatherData.main.temp
                fetchedData.maxTemp = weatherData.main.temp_max
                fetchedData.minTemp = weatherData.main.temp_min
                fetchedData.humidity = weatherData.main.humidity
                fetchedData.windSpeed = weatherData.wind.speed
                fetchedData.mainDesc = weatherData.weather[0].main
                fetchedData.country = weatherData.sys.country
                self.weatherDataM.onNext(fetchedData)
            } catch let error {
                fatalError("error fetching weather data \(String(describing: error))")
            }
        }.resume()
    }
}
