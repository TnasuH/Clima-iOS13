//
//  WeatherManager.swift
//  Clima
//
//  Created by Tarık Nasuhoğlu on 7.09.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1d97dcb3c594fc0f575de790514b26eb&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string:urlString) {
            let session = URLSession(configuration: .default)
            
            //let task = session.dataTask(with: url, completionHandler: handle(data, response, error))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume();
        }
    }
    
    func parseJSON(_ weather:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weather)
            let weather = WeatherModel(conditionId: (decodedData.weather?[0].id)!, cityName: decodedData.name!, temperature: (decodedData.main?.temp)!)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

