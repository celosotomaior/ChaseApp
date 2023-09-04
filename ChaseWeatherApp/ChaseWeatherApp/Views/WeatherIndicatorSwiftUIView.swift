//
//  WeatherIndicatorSwiftUIView.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 04/09/2023.
//

import SwiftUI

struct WeatherIndicatorSwiftUIView: View {
    var weatherCondition: String
    var body: some View {
        HStack {
            Image(systemName: weatherCondition)
                .resizable()
        }
        .padding()
    }
}
