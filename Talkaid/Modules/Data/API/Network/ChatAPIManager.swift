import Foundation

protocol ChatAPIManagerProtocol {
  func sendMessage(_ message: String) async throws -> String
}

final class MockChatAPIManager: ChatAPIManagerProtocol {
  func sendMessage(_ message: String) async throws -> String {
    try await Task.sleep(for: 1.5)
    let response = "Hello, how can I assist you?"
    return response
  }
}
