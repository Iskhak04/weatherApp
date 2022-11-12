//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Iskhak Zhutanov on 11/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewModel: NSObject {
    
    let bag = DisposeBag()
    
    let model = WeatherModel()
    
    var cityNameVM = PublishSubject<String>()
    var weatherDataVM = PublishSubject<WeatherData>()
    
    override init() {
        super.init()
        
        cityNameVM.subscribe(onNext: {
            self.model.cityNameM.onNext($0)
        }).disposed(by: bag)
        
        model.weatherDataM.subscribe(onNext: {
            self.weatherDataVM.onNext($0)
        }).disposed(by: bag)
        
    }
}
