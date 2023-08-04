import Foundation

// MARK: - NetworkError

enum NetworkError {
  case invalidServerResponse
  case invalidURL
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "The server returned an invalid response."
    case .invalidURL:
      return "The URL is invalid."
    }
  }
}
