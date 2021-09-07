//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: identifiers
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextUI: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var count = 0
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextUI.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    @IBAction func findCurrentLocationWeatherPressed(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchBtnPressed(_  sender: UIButton) {
        searchTextUI.endEditing(true)
    }
}

// MARK: - CLLocationManagerDelegate Extension Methods
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = "\(location.coordinate.latitude)"
            let lon = "\(location.coordinate.longitude)"
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("an error on location manager \(error)")
    }
}

// MARK: - UITextFieldDelegate Extension Methods
extension WeatherViewController: UITextFieldDelegate {
    
    
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
}

// MARK: - WeatherManagerDelegate Extension Methods
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
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
