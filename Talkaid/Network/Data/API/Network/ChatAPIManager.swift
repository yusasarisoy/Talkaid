import Foundation

protocol ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble
}

final class MockChatAPIManager: ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble {
    try await Task.sleep(for: 1.5)
    let message = "Hello, how can I assist you?"
    return ChatBubble(content: message, sender: .chatAssistant)
  }
}
