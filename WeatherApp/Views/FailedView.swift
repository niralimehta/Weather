//
//  FailedView.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/29/24.
//

import SwiftUI

struct FailedView: View {
    
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 50) {
            Text("\(errorMessage)")
            Image("oops")
        }
        // errorMessage = "Location weather data not found."
        // errorMessage = "City not found or API error."
    }
}

#Preview {
    FailedView(errorMessage: "Error")
}
