import Foundation

class WeatherModel: ObservableObject {
    @Published var conditionId: Int
    @Published var cityName: String
    @Published var temperature: Double
    @Published var tempMax: Double
    @Published var tempMin: Double
    
    init(id: Int, city: String, temp: Double, tempMax: Double, tempMin: Double) {
        conditionId = id
        cityName = city
        temperature = temp
        self.tempMax = tempMax
        self.tempMin = tempMin
    }
    
    static var defaultWeather: WeatherModel {
        WeatherModel(id: 0, city: "", temp: 0.0, tempMax: 0.0, tempMin: 0.0)
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var tempMaxString: String {
        return String(format: "%.1f", tempMax)
    }
    
    var tempMinString: String {
        return String(format: "%.1f", tempMin)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
