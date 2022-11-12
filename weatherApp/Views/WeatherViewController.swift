//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Iskhak Zhutanov on 11/11/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    
    // Clouds: broken clouds, few clouds,
    // Thunderstorm: thunderstorm with rain,
    // Clear: clear sky,
    // Haze: haze,
    // Rain: moderate rain, light rain,
    // Smoke: smoke,
    // Drizzle: light intensity drizzle,
    // Fog: fog,
    
    enum weatherIcons: String {
        case humidity = "humidity"
        case wind = "wind"
        case maxTemp = "thermometer.high"
        case minTemp = "thermometer.low"
        case Clear = "sun.min"
        case Thunderstorm = "cloud.bolt"
        case Smoke = "smoke"
        case Drizzle = "cloud.drizzle"
        case Rain = "cloud.heavyrain"
        case Clouds = "cloud"
        case Haze = "sun.haze"
        case Fog = "cloud.fog"
    }
    
    let bag = DisposeBag()
    
    private let viewModel = WeatherViewModel()
    
    private var weatherData = WeatherData(temperature: 0, maxTemp: 0, minTemp: 0, humidity: 0, windSpeed: 0, mainDesc: "", country: "")
        
    var city: String?
    
    private lazy var locationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "mappin.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large))
        view.tintColor = .white
        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 25)
        view.textColor = .white
        return view
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let view = UIImageView()
        //view.image = UIImage(systemName: weatherIcons.Rain.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        view.tintColor = .white
        return view
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial",size: 100)
        view.textColor = .white
        //view.backgroundColor = .red
        view.textAlignment = .right
        return view
    }()
    
    private lazy var  statBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private lazy var maxTempImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: weatherIcons.maxTemp.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .large))
        view.tintColor = .blue
        return view
    }()
    
    private lazy var maxTempTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Max. temp."
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 16)
        return view
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let view = UILabel()
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 30)
        return view
    }()
    
    private lazy var minTempImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: weatherIcons.minTemp.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .large))
        view.tintColor = .blue
        return view
    }()
    
    private lazy var minTempTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Min. temp."
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 16)
        return view
    }()
    
    private lazy var minTempLabel: UILabel = {
        let view = UILabel()
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 30)
        return view
    }()
    
    private lazy var humidityImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: weatherIcons.humidity.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large))
        view.tintColor = .blue
        return view
    }()
    
    private lazy var humidityTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Humidity"
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 16)
        return view
    }()
    
    private lazy var humidityLabel: UILabel = {
        let view = UILabel()
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 30)
        return view
    }()
    
    private lazy var windImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: weatherIcons.wind.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large))
        view.tintColor = .blue
        return view
    }()
    
    private lazy var windTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Wind speed"
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 16)
        return view
    }()
    
    private lazy var windLabel: UILabel = {
        let view = UILabel()
        view.textColor = .blue
        view.font = UIFont(name: "Arial", size: 24)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        viewModel.weatherDataVM.subscribe(onNext: {
            self.weatherData = $0
        }).disposed(by: bag)
        
        viewModel.cityNameVM.onNext(city!)
        
        while weatherData.temperature == 0 {
            
        }
        
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationLabel.text = "\(city!), \(weatherData.country)"
        temperatureLabel.text = "\(weatherData.temperature)°"
        maxTempLabel.text = "\(weatherData.maxTemp)°"
        minTempLabel.text = "\(weatherData.minTemp)°"
        humidityLabel.text = "\(weatherData.humidity)%"
        windLabel.text = "\(weatherData.windSpeed)km/h"
        
        switch weatherData.mainDesc {
        case "Clear":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Clear.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Rain":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Rain.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Haze":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Haze.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Thunderstorm":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Thunderstorm.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Clouds":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Clouds.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Drizzle":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Drizzle.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        case "Smoke":
            weatherIconImageView.image = UIImage(systemName: weatherIcons.Smoke.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .medium, scale: .large))
        default:
            ()
        }
    }

    private func layout() {
        view.backgroundColor = .blue
        
        view.addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(105)
            make.left.equalTo(view.snp.left).offset(20)
        }
        
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(105)
            make.left.equalTo(locationImageView.snp.right).offset(12)
        }
        
        view.addSubview(weatherIconImageView)
        weatherIconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.top.equalTo(locationLabel.snp.bottom).offset(70)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.width.equalTo(300)
        }
        
        view.addSubview(statBackgroundView)
        statBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(200)
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(280)
        }
        
        statBackgroundView.addSubview(maxTempImageView)
        maxTempImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalToSuperview().offset(40)
        }
        
        statBackgroundView.addSubview(maxTempTitleLabel)
        maxTempTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalTo(maxTempImageView.snp.right).offset(13)
        }
        
        statBackgroundView.addSubview(maxTempLabel)
        maxTempLabel.snp.makeConstraints { make in
            make.top.equalTo(maxTempTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(maxTempImageView.snp.right).offset(13)
        }
        
        statBackgroundView.addSubview(minTempImageView)
        minTempImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-120)
        }
        
        statBackgroundView.addSubview(minTempTitleLabel)
        minTempTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalTo(minTempImageView.snp.right).offset(13)
        }
        
        statBackgroundView.addSubview(minTempLabel)
        minTempLabel.snp.makeConstraints { make in
            make.top.equalTo(minTempTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(minTempImageView.snp.right).offset(13)
        }
        
        statBackgroundView.addSubview(humidityImageView)
        humidityImageView.snp.makeConstraints { make in
            make.top.equalTo(maxTempImageView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(40)
        }
        
        statBackgroundView.addSubview(humidityTitleLabel)
        humidityTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(maxTempImageView.snp.bottom).offset(50)
            make.left.equalTo(humidityImageView.snp.right).offset(10)
        }
        
        statBackgroundView.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(humidityImageView.snp.right).offset(10)
        }
        
        statBackgroundView.addSubview(windImageView)
        windImageView.snp.makeConstraints { make in
            make.top.equalTo(minTempImageView.snp.bottom).offset(50)
            make.right.equalToSuperview().offset(-120)
        }
        
        statBackgroundView.addSubview(windTitleLabel)
        windTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(minTempImageView.snp.bottom).offset(50)
            make.left.equalTo(windImageView.snp.right).offset(13)
        }
        
        statBackgroundView.addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(windTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(windImageView.snp.right).offset(13)
        }
    }
}
