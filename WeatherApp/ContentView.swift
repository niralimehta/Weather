//
//  ContentView.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/16/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var weather: Weather?
    @State private var city: String = ""
    @State private var errorMessage: String?
    
    let weatherService = WeatherData()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter City", text: $city)
                    .padding()
                    .border(Color.gray)
                
                Button("Search") {
                    fetchWeatherForCity()
                }
                .padding()
            }
            
            if let weather = weather {
                Text("Weather in \(weather.name)")
                    .font(.title)
                Text("Temperature: \(String(format: "%.1f", weather.main.temp))°C")
                Text("Humidity: \(weather.main.humidity)%")
                Text("Condition: \(weather.weather.first?.description ?? "")")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            if let location = locationManager.userLocation {
                Button("Use Current Location") {
                    fetchWeatherForLocation(location: location)
                }
            }
        }
        .padding()
        .onAppear {
            loadLastSearchedCity()
        }
    }
    
    private func fetchWeatherForCity() {
        weatherService.fetchWeather(byCity: city) { fetchedWeather in
            if let fetchedWeather = fetchedWeather {
                self.weather = fetchedWeather
                saveLastSearchedCity()
            } else {
                self.errorMessage = "City not found or API error."
            }
        }
    }
    
    private func fetchWeatherForLocation(location: CLLocation) {
        weatherService.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { fetchedWeather in
            if let fetchedWeather = fetchedWeather {
                self.weather = fetchedWeather
            } else {
                self.errorMessage = "Location weather data not found."
            }
        }
    }
    
    private func saveLastSearchedCity() {
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
    }
    
    private func loadLastSearchedCity() {
        if let savedCity = UserDefaults.standard.string(forKey: "lastSearchedCity") {
            self.city = savedCity
            fetchWeatherForCity()
        }
    }
}
#Preview {
    ContentView()
}
