import Combine

final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var chatMessages: [ChatBubble] = []

  // MARK: - Initialization

  init() {

  }
}

// MARK: - Internal Helper Methods

extension ChatViewModel {
  func sendMessage(_ message: String) {
    let newMessage = ChatBubble(content: message, sender: .user)
    chatMessages.append(newMessage)
  }
}
