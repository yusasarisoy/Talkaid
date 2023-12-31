import Foundation

// MARK: - Chat

struct Chat: Decodable {
  let id, object: String?
  let created: Int?
  let model: String?
  let usage: Usage?
  let choices: [Choice]?
}

// MARK: - Choice

struct Choice: Decodable {
  let message: Message?
  let finishReason: String?
  let index: Int?

  enum CodingKeys: String, CodingKey {
    case message
    case finishReason = "finish_reason"
    case index
  }
}

// MARK: - Message

struct Message: Decodable {
  let role: String?
  let content: String?
}

// MARK: - Usage

struct Usage: Decodable {
  let promptTokens: Int?
  let completionTokens: Int?
  let totalTokens: Int?

  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}

// MARK: - Fetch Mock Data

extension Chat {
  static func fetchMockData() -> Chat? {
    guard
      let url = Bundle.main.url(forResource: "ChatMock", withExtension: "json"),
      let data = try? Data(contentsOf: url)
    else {
      return nil
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let jsonMock = try? decoder.decode(ChatMock.self, from: data)
    return jsonMock?.chat
  }
}
