// MARK: - ChatAPIManagerProtocol

protocol ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble
  func greetUser(with greetUser: GreetUser) async throws -> GreetUser
}

// MARK: - MockChatAPIManager

final class MockChatAPIManager {

  // MARK: - Properties
  
  var greetUserReturnValue: GreetUser?
}

// MARK: - ChatAPIManagerProtocol

extension MockChatAPIManager: ChatAPIManagerProtocol {
  func sendMessage() async throws -> ChatBubble {
    try await Task.sleep(for: 1.5)
    let message = "Hello, how can I assist you?"
    return ChatBubble(content: message, sender: .chatAssistant)
  }
  
  func greetUser(with greetUser: GreetUser) async throws -> GreetUser {
    try await Task.sleep(for: 1.5)
    let greetUser = GreetUser(
      title: greetUser.title,
      description: greetUser.description
    )
    greetUserReturnValue = greetUser
    return greetUser
  }
}
