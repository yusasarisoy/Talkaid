import Combine

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var inputText: String = ""
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
  func sendMessage(_ message: ChatBubble) async {
    guard !(message.content?.isEmpty ?? false) else {
      // TODO: - Show an alert
      return
    }
    inputText = ""
    isLoading = true
    chatMessages.append(message)
    do {
      guard message.sender == .user else { return }
      let chatAssistantMessage = try await chatAPIManager.sendMessage()
      chatMessages.append(chatAssistantMessage)
    } catch {
      // TODO: - Handle the error.
    }
    isLoading = false
  }
}
