//
//  TemperatureSwiftUIView.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 04/09/2023.
//

import SwiftUI

struct TemperatureSwiftUIView: View {
    var temperature: Double
    var body: some View {
        HStack(alignment: .top) {
            Text(String(format: "%.f", temperature))
                    .font(.system(size: 100, weight: .bold, design: .rounded))
            Text("℃")
                .font(.system(size: 100, weight: .light, design: .rounded))
        }
        .padding(.trailing)
    }
}
