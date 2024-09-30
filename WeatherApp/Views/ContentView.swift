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
            .padding()
            
            HStack() {
                if let weather = self.weatherViewModel.weather {
                    if let image = self.weatherViewModel.weatherIconImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "cloud.rain")
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    VStack {
                        Text("Weather in \(weather.name)")
                            .font(.title)
                        Text("Temperature: \(String(format: "%.1f", weather.weatherCondition.temp))°C")
                        Text("Humidity: \(weather.weatherCondition.humidity)%")
                        Text("Condition: \(weather.weather.first?.description ?? "")")
                    }
                    
                    
                } else if let errorMessage = self.weatherViewModel.errorMessage {
                    FailedView(errorMessage: errorMessage)
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            if let location = locationManager.userLocation {
                Button("Use Current Location") {
                    self.weatherViewModel.getWeatherForLocation(location: location)
                }
            }
        }
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
