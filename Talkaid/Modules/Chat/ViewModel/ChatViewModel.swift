import Combine

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var inputText: String = .empty
  @Published var showVoiceInput: Bool = false
  @Published var isLoading = true
  @Published var chatMessages: [ChatBubble] = []
  @Published var errorType: Error?
  @Published var greetUser = GreetUser(title: .empty, description: .empty)

  private let chatAPIManager: ChatAPIManagerProtocol

  // MARK: - Initialization

  init(chatAPIManager: ChatAPIManagerProtocol = MockChatAPIManager()) {
    self.chatAPIManager = chatAPIManager
  }
}

// MARK: - Internal Helper Methods

extension ChatViewModel {
  func greetTheUser() async throws {
    isLoading = true
    greetUser = try await chatAPIManager.greetUser(
      with: GreetUser(
        title: "Good morning, Samantha",
        description: "How can I help you today?"
      )
    )
    isLoading = false
  }

  func sendMessage(_ message: ChatBubble) async throws {
    inputText = .empty
    guard message.content.isTextContainsCharacter else {
      errorType = .emptyMessage
      return
    }
    isLoading = true
//    Task {
      chatMessages.append(message)
      do {
        guard message.sender == .user else { return }
        let chatAssistantMessage = try await chatAPIManager.sendMessage()
        chatMessages.append(chatAssistantMessage)
      } catch {
        errorType = .unableToConnectToChatAssistant
      }
//    }
    isLoading = false
  }
}
