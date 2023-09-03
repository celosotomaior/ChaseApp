//
//  WeatherViewModel.swift
//  Clima
//
//  Created by Marcelo Sotomaior on 02/09/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import Combine
import os
import CoreLocation

class  WeatherViewModel : NSObject, ObservableObject {
    @Published var weatherModel: WeatherModel = WeatherModel.defaultWeather
    
    private let weatherService: GetWeatherAPIOperation
    private let weatherManagerUsingDataTask: WeatherManagerUsingDataTask
    private let reusableUserDefaults = ReusableUserDefaults()
    
    private var sub = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    var delegate: WeatherViewModelDelegate?
    init(weatherService: GetWeatherAPIOperation, weatherManagerUsingDataTask: WeatherManagerUsingDataTask) {
        self.weatherService = GetWeatherAPIOperation()
        self.weatherManagerUsingDataTask = weatherManagerUsingDataTask
        super.init()
       
    }
    
    public func canAccessLocation() -> Bool {
        let access = CLLocationManager.authorizationStatus()
        return access == .authorizedAlways || access == .authorizedWhenInUse
    }
    
    func requestLocationData() {
        if(CLLocationManager.authorizationStatus() == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        if(canAccessLocation()){
            self.locationManager.requestLocation()
        }
    }
    // Combine
    func getWeather(for city: String){
        weatherService.fetchDaySummary(for: city)
            .map {
                self.delegate?.didUpdateWeather(self, weather: WeatherModel(id:$0.weather[0].id,city: $0.name,temp: $0.main.temp, tempMax: $0.main.temp_max, tempMin: $0.main.temp_min))
                self.reusableUserDefaults.set(value: $0.name as String, forKey: UserDefaultKeys.city)
              return  WeatherModel(id:$0.weather[0].id,city: $0.name,temp: $0.main.temp, tempMax: 0.0, tempMin: 0.0)
            }
            .replaceError(with: WeatherModel(id: 0, city: "", temp: 0.0, tempMax: 0.0, tempMin: 0.0))
            .receive(on: DispatchQueue.main)
            .assign(to: \.weatherModel, on: self)
            .store(in: &sub)
    }
    
    // Regular DataTask
    func fetchWeatherDataUsingDataTask(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        weatherManagerUsingDataTask.fetchWeather(latitude: latitude, longitude: longitude)  {
            self.reusableUserDefaults.set(value: $0.cityName, forKey: UserDefaultKeys.city)
            self.delegate?.didUpdateWeather(self, weather: WeatherModel(id:$0.conditionId,city: $0.cityName, temp: $0.temperature, tempMax: $0.tempMax, tempMin: $0.tempMin))
        }
    }
    // Regular DataTask
    func fetchWeatherDataUsingDataTask(for city: String) {
        weatherManagerUsingDataTask.fetchWeather(cityName: city)  {
            self.reusableUserDefaults.set(value: $0.cityName, forKey: UserDefaultKeys.city)
            self.delegate?.didUpdateWeather(self, weather: WeatherModel(id:$0.conditionId,city: $0.cityName, temp: $0.temperature, tempMax: $0.tempMax, tempMin: $0.tempMin))
        }
    }
    
    func getWeatherForCurrentLocation() {
        self.requestLocationData()
    }
    // Combine
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        weatherService.fetchDaySummary(latitude, longitude)
            .replaceError(with: WeatherData(name: "", main: Main(temp: 0.0, temp_min: 0.0, temp_max: 0.0), weather: [Weather(description: "", id: 0)])) // Replace with your actual WeatherData type
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] weatherData in
                guard let self = self else { return }

                // Extract the necessary data and call the delegate method
                let weatherModel = WeatherModel(id: weatherData.weather[0].id, city: weatherData.name, temp: weatherData.main.temp, tempMax: weatherData.main.temp_max, tempMin: weatherData.main.temp_min)
                self.reusableUserDefaults.set(value: weatherData.name, forKey: UserDefaultKeys.city)
                self.delegate?.didUpdateWeather(self, weather: weatherModel)
            })
            .store(in: &sub)
    }

}
