import Foundation

// MARK: - DataParserProtocol

protocol DataParserProtocol {
  func parse<Element: Decodable>(data: Data) throws -> Element
}

// MARK: - DataParser

final class DataParser {

  // MARK: - Properties

  private let jsonDecoder: JSONDecoder

  // MARK: - Initialization

  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }
}

// MARK: - DataParserProtocol

extension DataParser: DataParserProtocol {
  func parse<Element: Decodable>(data: Data) throws -> Element {
    return try jsonDecoder.decode(Element.self, from: data)
  }
}
