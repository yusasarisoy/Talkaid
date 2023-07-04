import Combine

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var inputText: String = ""
  @Published var isLoading = false
  @Published var chatMessages: [ChatBubble] = []
  @Published var errorType: Error?

  private let chatAPIManager: ChatAPIManagerProtocol

  // MARK: - Initialization

  init(chatAPIManager: ChatAPIManagerProtocol = MockChatAPIManager()) {
    self.chatAPIManager = chatAPIManager
  }
}

// MARK: - Internal Helper Methods

extension ChatViewModel {
  func sendMessage(_ message: ChatBubble) async {
    inputText = ""
    guard message.content.isTextContainsCharacter else {
      errorType = .emptyMessage
      return
    }
    isLoading = true
    chatMessages.append(message)
    do {
      guard message.sender == .user else { return }
      let chatAssistantMessage = try await chatAPIManager.sendMessage()
      chatMessages.append(chatAssistantMessage)
    } catch {
      errorType = .unableToConnectToChatAssistant
    }
    isLoading = false
  }
}
