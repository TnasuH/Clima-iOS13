//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    //MARK: identifiers
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextUI: UITextField!
    
    var weatherManager = WeatherManager()
    var weather: WeatherModel?
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextUI.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func searchBtnPressed(_  sender: UIButton) {
        searchTextUI.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextUI.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextUI.text != "" {
            return true
        }
        textField.placeholder = "Type something"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextUI.placeholder = "Search"
        if let city = searchTextUI.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextUI.text = ""
    }
    
    // MARK: - WeatherManagerDelegate Methods
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.weather = weather
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            print(error)
            let alertController = UIAlertController(title: "There was an error", message: "\(error)", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true)
        }
    }
    
}

