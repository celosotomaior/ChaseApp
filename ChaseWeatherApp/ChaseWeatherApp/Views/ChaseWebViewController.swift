//
//  ChaseWebViewController.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import SwiftUI

struct ChaseWebView: View {

    @ObservedObject var weatherViewModel: WeatherViewModel
    @State var cityName: String = ""
    @State var showEmptySearchAlert = false
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }
    
    var body: some View {
        ZStack {
            Image("background 1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
                .edgesIgnoringSafeArea(.all)
            VStack {
                SearchBar(searchTerm: $cityName, action: lookupWeather)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                HStack {
                    Spacer()
                    WeatherConditionIndicator(weatherCondition: self.weatherViewModel.weatherModel.conditionName)
                        .frame(width: 120, height: 120, alignment: .center)
                }
                HStack(alignment: .top) {
                    Spacer()
                    TemperatureView(temperature: self.weatherViewModel.weatherModel.temperature)
                }
                HStack(alignment: .top) {
                    Spacer()
                    Text(self.weatherViewModel.weatherModel.cityName)
                        .font(.system(size: 30))
                }
                .padding(.trailing)
                
                Spacer()
            }
            Spacer()
        }
        .font(.system(.body, design: .rounded))
        .alert(isPresented: $showEmptySearchAlert) {
            Alert(title: Text("City"), message: Text("Enter city name"), dismissButton: .cancel())
        }
 
    }

    func lookupWeather() {
        guard cityName.count > 0 else {
            showEmptySearchAlert = true
            return
        }
        
        // Get the weather
        weatherViewModel.getWeather(for: cityName)
    }
}

struct TemperatureView: View {
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

struct WeatherConditionIndicator: View {
    var weatherCondition: String
    var body: some View {
        HStack {
            Image(systemName: weatherCondition)
                .resizable()
        }
        .padding()
    }
}

struct SearchBar: View {
    @State var placeholder: String = "Search"
    @Binding var searchTerm: String
    var action: () -> Void
    
    var body: some View {
        HStack {
           
            TextField(placeholder, text: $searchTerm, onCommit: action)
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 5.0, style: .continuous).fill(Color.gray))
            .autocapitalization(.words)
            .keyboardType(.webSearch)
            .multilineTextAlignment(.leading)
            
            Button(action: action, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .padding(.all, 5)
                    .foregroundColor(Color.blue)
            })
            .frame(width: 40, height: 40, alignment: .leading)
           
        }
    }
}

struct ChaseWebView_Previews: PreviewProvider {
    @State static var searchTerm = ""
    static var previews: some View {
        Group {
            ChaseWebView(weatherViewModel: WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask()))
            ChaseWebView(weatherViewModel: WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask()))
                .preferredColorScheme(.dark)
        }
    }
}
