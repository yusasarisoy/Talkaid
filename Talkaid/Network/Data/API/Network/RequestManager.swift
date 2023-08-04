// MARK: - RequestManagerProtocol

protocol RequestManagerProtocol {
  func perform<Element: Decodable>(_ request: RequestProtocol) async throws -> Element
}

// MARK: - RequestManager

final class RequestManager {

  // MARK: - Properties

  private let apiManager: APIManagerProtocol
  private let parser: DataParserProtocol

  // MARK: - Initialization

  init(
    apiManager: APIManagerProtocol = APIManager(),
    parser: DataParserProtocol = DataParser()
  ) {
    self.apiManager = apiManager
    self.parser = parser
  }
}

// MARK: - RequestManagerProtocol

extension RequestManager: RequestManagerProtocol {
  func perform<Element: Decodable>(_ request: RequestProtocol) async throws -> Element {
    let data = try await apiManager.perform(request)
    let decoded: Element = try parser.parse(data: data)
    return decoded
  }
}
