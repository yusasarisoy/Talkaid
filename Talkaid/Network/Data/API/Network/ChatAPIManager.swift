protocol ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble
  func greetUser() async throws -> GreetUser
}

final class MockChatAPIManager: ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble {
    try await Task.sleep(for: 1.5)
    let message = "Hello, how can I assist you?"
    return ChatBubble(content: message, sender: .chatAssistant)
  }
  
  func greetUser() async throws -> GreetUser {
    try await Task.sleep(for: 0.5)
    let greetUser = GreetUser(
      title: "Good morning, Samantha",
      description: "How can I help you today?"
    )
    return greetUser
  }
}
