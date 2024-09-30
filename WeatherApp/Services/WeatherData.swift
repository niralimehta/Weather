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

class WeatherService {
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<Weather, NetworkError>) -> Void) {
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
                completion(.success(weather))
            }
        }.resume()
    }
    
    func fetchWeather(byCity city: String, completion: @escaping (Result<Weather, NetworkError>) -> Void) {
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
                completion(.success(weather))
            }
        }.resume()
        
    }
}
