import Combine

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var isLoading = false
  @Published var chatMessages: [ChatBubble] = []

  private let chatAPIManager: ChatAPIManagerProtocol

  // MARK: - Initialization

  init(chatAPIManager: ChatAPIManagerProtocol = MockChatAPIManager()) {
    self.chatAPIManager = chatAPIManager
  }
}

// MARK: - Internal Helper Methods

extension ChatViewModel {
  func sendMessage(_ message: String) {
    Task {
      isLoading = true
      let newMessage = ChatBubble(content: message, sender: .user)
      chatMessages.append(newMessage)
      do {
        let response = try await chatAPIManager.sendMessage(message)
        let chatAssistantMessage = ChatBubble(content: response, sender: .chatAssistant)
        chatMessages.append(chatAssistantMessage)
      } catch {
        // TODO: - Handle the error.
      }
      isLoading = false
    }
  }
}
