//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import Foundation
import CoreLocation
import SwiftUI

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

struct WeatherResponse {
    var weather: Weather
    var icon: UIImage?
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
            
            if let iconCode = weather.weather.first?.icon {
                self.fetchWeatherIcon(by: iconCode) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(WeatherResponse(weather: weather, icon: data)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.success(WeatherResponse(weather: weather, icon: nil)))
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
            
            if let iconCode = weather.weather.first?.icon {
                self.fetchWeatherIcon(by: iconCode) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(WeatherResponse(weather: weather, icon: data)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.success(WeatherResponse(weather: weather, icon: nil)))
            }
            
        }.resume()
        
    }
    
    func fetchWeatherIcon(by code: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        // Check if the image is cached, read from cache.
        if let cachedImage = ImageCache.shared.object(forKey: code as NSString) {
            completion(.success(cachedImage))
        }
        
        // Otherwise, download the image from url and store in cache.
        guard let url = URL.getImageData(by: code) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(.failure(.noData))
                return
            }
            // Cache the image
            ImageCache.shared.setObject(image, forKey: code as NSString)
            completion(.success(image))
            
        }.resume()
        
    }
}
