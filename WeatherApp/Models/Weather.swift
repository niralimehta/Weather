//
//  Weather.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import Foundation

struct Weather: Codable {
    let name: String
    let weatherCondition: WeatherCondition
    let weather: [WeatherDescription]
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case weatherCondition = "main"
        case weather = "weather"
    }
}

struct WeatherCondition: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDescription: Codable {
    let description: String
    let icon: String

}
