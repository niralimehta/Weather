//
//  URL+Extensions.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import Foundation
import CoreLocation

extension URL {
    
    static func getWeatherDataBy(city: String) -> URL? {
        return URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.API_KEY)&units=metric")
    }
    
    static func getWeatherDataBy(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? {
        return URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.API_KEY)&units=metric")

    }
}
