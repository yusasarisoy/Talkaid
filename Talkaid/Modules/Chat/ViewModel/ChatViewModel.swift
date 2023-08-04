import Combine

// MARK: - ChatFetcher

protocol ChatFetcher {
  func fetchCompletions(prompt: String) async -> Chat?
}

@MainActor
final class ChatViewModel: ObservableObject {

  // MARK: - Properties

  @Published var inputText: String = .empty
  @Published var showVoiceInput: Bool = false
  @Published var isLoading = true
  @Published var chatMessages: [ChatBubble] = []
  @Published var errorType: Error?
  @Published var greetUser = GreetUser(title: .empty, description: .empty)

  private let chatFetcher: ChatFetcher

  // MARK: - Initialization

  init(chatFetcher: ChatFetcher) {
    self.chatFetcher = chatFetcher
  }
}

// MARK: - Internal Helper Methods

extension ChatViewModel {
  func greetTheUser() async throws {
    isLoading = true
    let chatAssistantMessage = await chatFetcher.fetchCompletions(prompt: "Hello Chat GPT")
    greetUser = .init(title: "Hello!", description: chatAssistantMessage?.choices?.first?.message?.content.orEmpty)
    isLoading = false
  }

  func sendMessage(_ message: ChatBubble) async throws {
    inputText = .empty
    guard message.content.isTextContainsCharacter else {
      errorType = .emptyMessage
      return
    }
    isLoading = true
    chatMessages.append(message)
    guard message.sender == .user else { return }
    let chatAssistantMessage = await chatFetcher.fetchCompletions(prompt: message.content.orEmpty)
    chatMessages.append(
      .init(
        content: chatAssistantMessage?.choices?.first?.message?.content.orEmpty,
        sender: .chatAssistant
      )
    )
    isLoading = false
  }
}
