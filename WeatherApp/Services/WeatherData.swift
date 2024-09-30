//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

struct WeatherResponse {
    var weather: Weather
    var iconData: Data?
}

class WeatherService {
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        guard let url = URL.getWeatherDataBy(latitude: latitude, longitude: longitude) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                return completion(.failure(.decodingError))
            }
            
            DispatchQueue.main.async {
                if let iconCode = weather.weather.first?.icon {
                    self.fetchWeatherIcon(by: iconCode) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(WeatherResponse(weather: weather, iconData: data)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.success(WeatherResponse(weather: weather, iconData: nil)))
                }
            }
        }.resume()
    }
    
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        guard let url = URL.getWeatherDataBy(city: city) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                return completion(.failure(.decodingError))
            }
            
            DispatchQueue.main.async {
                if let iconCode = weather.weather.first?.icon {
                    self.fetchWeatherIcon(by: iconCode) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(WeatherResponse(weather: weather, iconData: data)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.success(WeatherResponse(weather: weather, iconData: nil)))
                }
            }
        }.resume()
        
    }
    
    func fetchWeatherIcon(by code: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL.getImageData(by: code) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
            
        }.resume()
        
    }
}
