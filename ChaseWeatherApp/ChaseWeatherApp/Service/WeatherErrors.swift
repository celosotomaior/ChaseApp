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
