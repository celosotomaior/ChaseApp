import SwiftUI

struct WeatherSwiftUIView: View {
    
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
                SearchSwiftUIView(searchTerm: $cityName, action: lookupWeather)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                HStack {
                    Spacer()
                    WeatherIndicatorSwiftUIView(weatherCondition: self.weatherViewModel.weatherModel.conditionName)
                        .frame(width: 120, height: 120, alignment: .center)
                }
                HStack(alignment: .top) {
                    Spacer()
                    TemperatureSwiftUIView(temperature: self.weatherViewModel.weatherModel.temperature)
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

struct WeatherSwiftUIView_Previews: PreviewProvider {
    @State static var searchTerm = ""
    static var previews: some View {
        Group {
            WeatherSwiftUIView(weatherViewModel: WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask()))
            WeatherSwiftUIView(weatherViewModel: WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask()))
                .preferredColorScheme(.dark)
        }
    }
}
