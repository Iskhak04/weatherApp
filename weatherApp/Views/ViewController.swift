//
//  ViewController.swift
//  weatherApp
//
//  Created by Iskhak Zhutanov on 11/11/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=cd93b58dce3ef8171d0fcd47dc3a64c6
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.text = "City name"
        view.font = UIFont(name: "Arial", size: 35)
        return view
    }()
    
    private lazy var cityTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "City name"
        view.borderStyle = .roundedRect
        view.font = UIFont(name: "Arial", size: 20)
        return view
    }()
    
    private lazy var enterButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.tintColor = .white
        view.setTitle("Enter", for: .normal)
        view.layer.cornerRadius = 30
        view.addTarget(self, action: #selector(enterButtonClicked), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cityTextField.text = ""
    }

    @objc func enterButtonClicked() {
        if let city = cityTextField.text, !city.isEmpty {
            let weatherVC = WeatherViewController()
            weatherVC.city = city
            navigationController?.pushViewController(weatherVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter city name!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width - 100)
            make.height.equalTo(40)
        }
        
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cityTextField.snp.top).offset(-50)
            make.centerX.equalTo(view.snp.centerX).offset(0)
        }
        
        view.addSubview(enterButton)
        enterButton.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(50)
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.height.equalTo(60)
            make.width.equalTo(180)
        }
    }
}

