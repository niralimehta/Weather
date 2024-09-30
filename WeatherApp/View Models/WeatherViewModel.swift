//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import Foundation
import CoreLocation

class WeatherViewModel : ObservableObject {
    
    @Published var weather: Weather?
    @Published var weatherIconData: Data?
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    init(weather: Weather? = nil) {
        self.weather = weather
    }
    
    func getWeatherForCity(_ city: String) {
        weatherService.fetchWeather(byCity: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weather = weather.weather
                    self.weatherIconData = weather.iconData
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.weather = nil
                    self.errorMessage = "City not found or API error."
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getWeatherForLocation(location: CLLocation) {
        weatherService.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weather = weather.weather
                    self.weatherIconData = weather.iconData
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.weather = nil
                    self.errorMessage = "Location weather data not found."
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
