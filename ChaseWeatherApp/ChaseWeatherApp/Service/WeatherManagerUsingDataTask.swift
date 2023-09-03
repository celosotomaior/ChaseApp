//
//  WeatherManagerUsingDataTask.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManagerUsingDataTask, weather: WeatherModel)
    func didFailWithError(error: Error)
}

public struct WeatherManagerUsingDataTask {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(GetWeatherAPIOperation.GetWeatherAPI.key)&units=metric"
    
    var delegate: WeatherViewModelDelegate?
    
    func fetchWeather(cityName: String, completion: @escaping (WeatherModel) -> Void) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherModel) -> Void) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString, completion: completion)
    }
    
    func performRequest(with urlString: String, completion: @escaping (WeatherModel)-> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        completion(weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let tempMax = decodedData.main.temp_max
            let tempMin = decodedData.main.temp_min
        
            let weather = WeatherModel(id: id, city: name, temp: temp, tempMax: tempMax, tempMin: tempMin)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


