import Foundation
import Combine


protocol WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

protocol WeatherInfo {
    func fetchDaySummary(for city: String) -> AnyPublisher<WeatherData, APIError>
    func fetchDaySummary(_ latitude: Double, _ longitude: Double) -> AnyPublisher<WeatherData, APIError>
}

class GetWeatherAPIOperation {
    private let session: URLSession

    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension GetWeatherAPIOperation: WeatherInfo {
    func fetchDaySummary(for city: String) -> AnyPublisher<WeatherData, APIError> {
        fetchAPI(with: createComponentsForCurrentDay(withCity: city))
    }
    
    // Define a function to make a network request
    func fetchDaySummary(_ lat: Double, _ lon: Double) -> AnyPublisher<WeatherData, APIError> {
        fetchAPI(with: createComponentsForCurrentDay(latitude: lat, longitude: lon))
    }

        func fetchAPI<T>(with urlComponents: URLComponents) -> AnyPublisher<T, APIError> where T: Decodable {
            guard let url = urlComponents.url else {
                let error = APIError.badURL
                return Fail(error: error).eraseToAnyPublisher()
            }
            let session = URLSession.shared
            return session.dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    guard let response = element.response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else {
                            throw self.mapStatusCodeToError(statusCode: (element.response as? HTTPURLResponse)?.statusCode)
                    }
                    return element.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    self.mapDecodingErrorToAPIError(error)
                }
                .eraseToAnyPublisher()
        }

        private func mapStatusCodeToError(statusCode: Int?) -> APIError {
            switch statusCode {
            case 400:
                return APIError.badRequest
            case 401:
                return APIError.unauthorized
            case 404:
                return APIError.notFound
            case 429:
                return APIError.tooManyRequests
            case 500:
                return APIError.serverError
            default:
                return APIError.unknown(message: "Unknown Error")
            }
        }

        private func mapDecodingErrorToAPIError(_ error: Error) -> APIError {
            // You can handle mapping decoding errors to APIError here
            // For simplicity, I'm returning a generic decoding error in this example
            return APIError.decodingError(message: error.localizedDescription)
        }

}

//MARK: - WeatherEndPoint
extension GetWeatherAPIOperation {
    struct GetWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "e591b03ad6e74acbbcf4dec432c1af16" // Save keys safely.
    }
    
    func createComponentsForCurrentDay(withCity city: String) -> URLComponents{
                var components = URLComponents()
            components.scheme = GetWeatherAPI.scheme
            components.host = GetWeatherAPI.host
            components.path = GetWeatherAPI.path + "/weather"
            
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "mode", value: "json"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: GetWeatherAPI.key)
            ]
            
            return components
        }
        
        func createComponentsForCurrentDay(latitude: Double, longitude: Double) -> URLComponents{
                var components = URLComponents()
            components.scheme = GetWeatherAPI.scheme
            components.host = GetWeatherAPI.host
            components.path = GetWeatherAPI.path + "/weather"
            
            components.queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "mode", value: "json"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: GetWeatherAPI.key)
            ]
            
            return components
        }
    }

