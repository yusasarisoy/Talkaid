import Foundation

protocol RequestProtocol {
  var path: String { get }
  var requestType: RequestType { get }
  var params: [String: Any] { get }
}

// MARK: - RequestProtocol
extension RequestProtocol {
  var host: String {
    APIConstants.host
  }

  var addAuthorizationToken: Bool {
    true
  }

  var params: [String: Any] {
    [:]
  }

  var urlParams: [String: String?] {
    [:]
  }

  func createURLRequest() throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    guard let url = components.url else { throw NetworkError.invalidURL }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestType.rawValue
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])

    return urlRequest
  }
}
