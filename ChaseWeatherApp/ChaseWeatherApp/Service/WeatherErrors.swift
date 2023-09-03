//
//  WeatherErrors.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import Foundation

enum APIError: Error {
    case badURL
    case badRequest
    case unauthorized
    case notFound
    case tooManyRequests
    case serverError
    case decodingError(message: String)
    case networkError(message: String)
    case unknown(message: String)
}
