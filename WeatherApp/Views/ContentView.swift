//
//  ContentView.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/27/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var weatherViewModel = WeatherViewModel()
    
    @StateObject var locationManager = LocationManager()
    @State private var city: String = ""
        
    var body: some View {
        VStack {
            HStack {
                TextField("Enter City", text: $city)
                    .padding()
                    .border(Color.gray)
                
                Button("Search") {
                    self.weatherViewModel.getWeatherForCity(city)
                }
                .padding()
            }
            
            if let weather = self.weatherViewModel.weather {
                Text("Weather in \(weather.name)")
                    .font(.title)
                Text("Temperature: \(String(format: "%.1f", weather.weatherCondition.temp))°C")
                Text("Humidity: \(weather.weatherCondition.humidity)%")
                Text("Condition: \(weather.weather.first?.description ?? "")")
            } else if let errorMessage = self.weatherViewModel.errorMessage {
                FailedView(errorMessage: errorMessage)
            }

            
            Spacer()
            
            if let location = locationManager.userLocation {
                Button("Use Current Location") {
                    self.weatherViewModel.getWeatherForLocation(location: location)
                }
            }
        }
        .padding()
        .onAppear {
            loadLastSearchedCity()
        }
    }
    
    private func saveLastSearchedCity() {
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
    }
    
    private func loadLastSearchedCity() {
        if let savedCity = UserDefaults.standard.string(forKey: "lastSearchedCity") {
            self.city = savedCity
            self.weatherViewModel.getWeatherForCity(city)
        }
    }
}
#Preview {
    ContentView()
}
