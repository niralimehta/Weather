//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/16/24.
//

import Foundation
import CoreLocation

struct Weather: Codable {
    let name: String
    let main: WeatherCondition
    let weather: [WeatherDescription]
}

struct WeatherCondition: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDescription: Codable {
    let description: String
}

class WeatherData {
    let apiKey = "fa96aced216ef95a383c8c54dd47988c"
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            DispatchQueue.main.async {
                completion(weather)
            }
        }.resume()
    }
    
    func fetchWeather(byCity city: String, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            DispatchQueue.main.async {
                completion(weather)
            }
        }.resume()
        
    }
}
